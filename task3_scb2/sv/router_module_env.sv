class router_module_env extends uvm_environment;

        `uvm_component_utils(router_module_env)

        router_scoreboard yapp_router_scb;
        router_reference yapp_router_ref;

    function new (string name, uvm_component parent);
        super.new(name,parent);                 
    endfunction

    virtual function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        yapp_router_scb = router_scoreboard::type_id::create("yapp_router_scb", this);
        yapp_router_ref = router_reference::type_id::create("yapp_router_ref", this);


    endfunction

    virtual function void connect_phase(uvm_phase phase);
        yapp_router_ref.yapp_to_ref.connect(yapp_router_scb.router_packet_in);

    endfunction


endclass