module cache #(
           parameter LINE_ADDR_LEN = 3,  // line�ڵ�ַ?�ȣ�������ÿ��line����2^3��word
           parameter SET_ADDR_LEN = 3,  // ���ַ?�ȣ�������һ����2^3=8��
           parameter TAG_ADDR_LEN = 6,  // tag?��
           parameter WAY_CNT = 3 // �������ȣ�������ÿ�����ж���·line
       )(
           input clk, rst,
           output miss,  // ��CPU������miss�ź�
           input [31: 0] addr,  // ��д�����ַ
           input rd_req,  // �������ź�
           output reg [31: 0] rd_data,  // ���������ݣ�һ�ζ�һ��word
           input wr_req,  // д�����ź�
           input [31: 0] wr_data // Ҫд?�����ݣ�?��дһ��word
       );
localparam MEM_ADDR_LEN = TAG_ADDR_LEN + SET_ADDR_LEN ; // ���������ַ?�� MEM_ADDR_LEN������?С=2^MEM_ADDR_LEN��line
localparam UNUSED_ADDR_LEN = 32 - TAG_ADDR_LEN - SET_ADDR_LEN - LINE_ADDR_LEN - 2 ; // ����δʹ?�ĵ�ַ��?��
localparam LINE_SIZE = 1 << LINE_ADDR_LEN ; // ���� line �� word ���������� 2^LINE_ADDR_LEN ��word ÿ line
localparam SET_SIZE = 1 << SET_ADDR_LEN ; // ����һ���ж����飬�� 2^SET_ADDR_LEN ����
reg [ 31: 0] cache_mem [SET_SIZE][WAY_CNT][LINE_SIZE]; // SET_SIZE��line��ÿ��line��LINE_SIZE��word
reg [TAG_ADDR_LEN - 1: 0] cache_tags [SET_SIZE][WAY_CNT]; // SET_SIZE��TAG
reg valid [SET_SIZE][WAY_CNT]; // SET_SIZE��valid(��Чλ)
reg dirty [SET_SIZE][WAY_CNT]; // SET_SIZE��dirty(��λ)
wire [ 2 - 1: 0] word_addr; // ����?��ַaddr��ֳ���5������
wire [ LINE_ADDR_LEN - 1: 0] line_addr;
wire [ SET_ADDR_LEN - 1: 0] set_addr;
wire [ TAG_ADDR_LEN - 1: 0] tag_addr;
wire [UNUSED_ADDR_LEN - 1: 0] unused_addr;
enum {IDLE, SWAP_OUT, SWAP_IN, SWAP_IN_OK} cache_stat; // cache ״̬����״̬����
// IDLE���������SWAP_OUT�������ڻ�����SWAP_IN�������ڻ�?��SWAP_IN_OK����?���??���ڵ�д?cache����
reg [ SET_ADDR_LEN - 1: 0] mem_rd_set_addr = 0;
reg [ TAG_ADDR_LEN - 1: 0] mem_rd_tag_addr = 0;
wire [ MEM_ADDR_LEN - 1: 0] mem_rd_addr = {mem_rd_tag_addr, mem_rd_set_addr};
reg [ MEM_ADDR_LEN - 1: 0] mem_wr_addr = 0;
reg [31: 0] mem_wr_line [LINE_SIZE];
wire [31: 0] mem_rd_line [LINE_SIZE];
wire mem_gnt; // ������Ӧ��д����?�ź�
assign {unused_addr, tag_addr, set_addr, line_addr, word_addr} = addr; // ��� 32bit ADDR
reg cache_hit = 1'b0;
enum {FIFO, LRU} swap_out_strategy;
integer time_cnt; //LRUʱ���¼
reg [WAY_CNT - 1: 0] way_addr; //����λ��
reg [WAY_CNT - 1: 0] out_way; //����λ��
reg [15: 0] LRU_record[SET_SIZE][WAY_CNT]; //ÿ?���LRU��¼
reg [WAY_CNT: 0] FIFO_record[SET_SIZE][WAY_CNT]; //ÿ?���ڵ�FIFO��λ��¼
always @ ( * ) begin // �ж���?��address �Ƿ��� cache ������,���û�����У���Ҫ��֮�����û�������
    cache_hit = 1'b0;
    for (integer i = 0; i < WAY_CNT; i = i + 1)
    begin
        if (valid[set_addr][i] && cache_tags[set_addr][i] == tag_addr) // ��� cache line��Ч������tag����?��ַ�е�tag��ȣ�������
        begin
            cache_hit = 1'b1;
            way_addr = i;
        end
    end
end
always @ ( * ) begin
    if (~cache_hit & (wr_req | rd_req))
    begin
        //LRU����ѡ����ͻʱ�����Ŀ�
        if (swap_out_strategy == LRU)
        begin
            for (integer i = 0; i < WAY_CNT; i = i + 1 )
            begin
                out_way = 0;
                if (LRU_record[set_addr][i] < LRU_record[set_addr][out_way])
                begin
                    out_way = i;
                end
            end
        end
        //FIFO����ѡ����ͻʱ�����Ŀ�
        else
        begin
            integer free = 0; //�Ƿ��п��п�ı�־
            for (integer i = 0;i < WAY_CNT ;i = i + 1 )
            begin
                if (FIFO_record[set_addr][i] == 0)
                begin
                    out_way = i;
                    free = 1;
                    break;
                end
            end
            if (free == 0)
            begin
                for (integer i = 0;i < WAY_CNT ;i = i + 1)
                begin //��ʱ˵��ʱ�����ȥ��
                    if (FIFO_record[set_addr][i] == WAY_CNT)
                    begin
                        out_way = i;
                        FIFO_record[set_addr][i] = 0; /*my adding*/
                        break;
                    end
                end
            end
            if (FIFO_record[set_addr][out_way] == 0)
            begin
                for (integer i = 0;i < WAY_CNT ;i = i + 1 )
                begin
                    if (FIFO_record[set_addr][i] != 0) begin
                        FIFO_record[set_addr][i] = FIFO_record[set_addr][i] + 1;
                    end
                end
            end
            FIFO_record[set_addr][out_way] = 1;
        end
    end
end
always @ (posedge clk or posedge rst) begin // ?? cache ???
    if (rst) begin
        cache_stat <= IDLE;
        time_cnt <= 0;
        swap_out_strategy <= LRU;
        //swap_out_strategy <= FIFO;
        for (integer i = 0;
                i < SET_SIZE;
                i = i + 1 ) begin
            for (integer j = 0;
                    j < WAY_CNT ;
                    j = j + 1) begin
                dirty[i][j] = 1'b0;
                valid[i][j] = 1'b0;
                LRU_record[i][j] = 0;
                FIFO_record[j][j] = 0;
            end
        end
        for (integer k = 0;
                k < LINE_SIZE;
                k = k + 1 )
            mem_wr_line[k] <= 0;
        mem_wr_addr <= 0;
        {mem_rd_tag_addr, mem_rd_set_addr} <= 0;
        rd_data <= 0;
    end else
    begin
        time_cnt= time_cnt + 1 ;
        case (cache_stat)
            IDLE: begin
                if (cache_hit) begin
                    if (rd_req) begin // ���cache���У������Ƕ�����
                        rd_data <= cache_mem[set_addr][way_addr][line_addr]; //��ֱ�Ӵ�cache��ȡ��Ҫ��������
                    end else if (wr_req) begin // ���cache���У�������д����
                        cache_mem[set_addr][way_addr][line_addr] <= wr_data; // ��ֱ����cache��д?����
                        dirty[set_addr][way_addr] <= 1'b1; // д���ݵ�ͬʱ����λ
                    end
                    LRU_record[set_addr][way_addr] <= time_cnt;
                end else
                begin
                    if (wr_req | rd_req) begin // ��� cache δ���У������ж�д��������Ҫ��?����
                        if (valid[set_addr]
                                [out_way] & dirty[set_addr][out_way]) begin // ��� Ҫ��?��cache line ������Ч�����࣬����Ҫ�Ƚ�������
                            cache_stat <= SWAP_OUT;
                            mem_wr_addr <= {cache_tags[set_addr][out_way], set_addr};
                            mem_wr_line <= cache_mem[set_addr][out_way];
                        end else
                        begin // ��֮������Ҫ������ֱ�ӻ�?
                            cache_stat <= SWAP_IN;
                        end
                        {mem_rd_tag_addr, mem_rd_set_addr} <= {tag_addr, set_addr};
                    end
                end
            end
            SWAP_OUT: begin
                if (mem_gnt) begin // ���������?�ź���Ч��˵�������ɹ���������?״̬
                    cache_stat <= SWAP_IN;
                end
            end
            SWAP_IN: begin
                if (mem_gnt) begin // ���������?�ź���Ч��˵����?�ɹ���������?״̬
                    cache_stat <= SWAP_IN_OK;
                end
            end
            SWAP_IN_OK: begin // ��?�����ڻ�?�ɹ��������ڽ����������lineд?cache��������tag����?valid���õ�dirty
                for (integer i = 0;
                        i < LINE_SIZE;
                        i=i+1 )
                    cache_mem[mem_rd_set_addr][out_way][i]<= mem_rd_line[i];
                                               cache_tags[mem_rd_set_addr][out_way] <= mem_rd_tag_addr;
                                               valid [mem_rd_set_addr][out_way] <= 1'b1;
                                               dirty [mem_rd_set_addr][out_way] <= 1'b0;
                                               LRU_record[mem_rd_set_addr][out_way] <= time_cnt;
                                               cache_stat <= IDLE; // �ص�����״̬
                                           end
                                   endcase
                               end
                           end
                           wire mem_rd_req = (cache_stat == SWAP_IN );
wire mem_wr_req = (cache_stat == SWAP_OUT);
wire [ MEM_ADDR_LEN - 1 : 0] mem_addr = mem_rd_req ? mem_rd_addr : ( mem_wr_req ? mem_wr_addr : 0);
assign miss = (rd_req | wr_req) & ~(cache_hit && cache_stat == IDLE) ; // �� �ж�д����ʱ�����cache�����ھ���(IDLE)״̬������δ���У���miss=1
main_mem #( // ���棬ÿ�ζ�д��line Ϊ��λ
             .LINE_ADDR_LEN ( LINE_ADDR_LEN ),
             .ADDR_LEN ( MEM_ADDR_LEN )
         ) main_mem_instance (
             .clk ( clk ),
             .rst ( rst ),
             .gnt ( mem_gnt ),
             .addr ( mem_addr ),
             .rd_req ( mem_rd_req ),
             .rd_line ( mem_rd_line ),
             .wr_req ( mem_wr_req ),
             .wr_line ( mem_wr_line )
         );
endmodule