class router_reference extends uvm_component;
        
    `uvm_component_utils(router_reference)

    uvm_analysis_port#(yapp_packet) yapp_to_ref; //one analysis port object for the valid YAPP packets, for output data to the scb

    //two analysis imp objects for the YAPP and HBUS monitor analysis ports
        `uvm_analysis_imp_decl(_yapp_reference) 
        `uvm_analysis_imp_decl(_hbus_reference)

        uvm_analysis_imp__yapp_reference#(yapp_packet, router_reference) yapp_packet_in;
        uvm_analysis_imp_hbus_reference#(hbus_transaction, router_reference) hbus_packet_in;
        
        //variables to mirror the maxpktsize and router_en register fields of the router

        bit [7:0] max_packet_size;
        bit [7:0] router_en;

        function new (string name, uvm_component parent);
            super.new(name,parent);
            //creating analysis implementations
            yapp_to_ref = new("yapp_to_ref", this);
            yapp_packet_in = new("yapp_packet_in", this);
            hbus_packet_in = new("hbus_packet_in", this);
           
        endfunction

        function void write_yapp_reference(input yapp_packet pkt);

            yapp_packet p_copy;
        $cast(p_copy,pkt.clone());
        if((p_copy.length <= max_packet_size) && (p_copy.addr < 3) && (router_en[0] == 1))
            yapp_to_ref.write(p_copy);
            else 
                `uvm_info(get_type_name(), $sformatf("packet with illegal address %0d recevied", p_copy.addr))
        endfunction

endclass