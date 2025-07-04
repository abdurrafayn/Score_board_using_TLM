class router_tb extends uvm_env;
    
`uvm_component_utils(router_tb)

    

    function new(string name ="router_tb", uvm_component parent);
        super.new(name, parent);
    endfunction: new
    
    // multiple UVCs (handles of UVCs)
    yapp_env environment;
    channel_env channel_0;
    channel_env channel_1;
    channel_env channel_2;

    hbus_env hbus;
    clock_and_reset_env clock_and_reset;
    router_mcsequencer mcseqr;

    router_scoreboard scoreboard;

    function void build_phase(uvm_phase phase);
    
        // environment = new("environment", this);
        super.build_phase(phase);
        `uvm_info("build_phase","Build base of base test is executing", UVM_HIGH);

        environment = yapp_env::type_id::create("environment", this);
        // using configuration set method to set the channel id

        uvm_config_int::set(this, "channel_0", "channel_id", 0);
        uvm_config_int::set(this, "channel_1", "channel_id", 1);
        uvm_config_int::set(this, "channel_2", "channel_id", 2);
        uvm_config_int::set(this, "hbus", "num_masters", 1);
        uvm_config_int::set(this, "hbus", "num_slaves", 0);

        uvm_config_int::set(this, "clock_and_reset", "channel_id", 2);

        channel_0 = channel_env::type_id::create("channel_0", this);
        channel_1 = channel_env::type_id::create("channel_1", this);
        channel_2 = channel_env::type_id::create("channel_2", this);
        hbus = hbus_env::type_id::create("hbus", this);
        clock_and_reset = clock_and_reset_env::type_id::create("clock_and_reset", this);
        mcseqr= router_mcsequencer::type_id::create("mcseqr", this);
        scoreboard = router_scoreboard::type_id::create("scoreboard",this);

    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
    mcseqr.hbus = hbus.masters[0].sequencer;
    mcseqr.yapp = environment.agent.sequencer;
    
    if (environment.agent.monitor == null)
    `uvm_fatal("NULL_MON", "environment.agent.monitor is NULL!")
    
    environment.agent.monitor.yapp_in.connect(scoreboard.router_packet_in);
    // `uvm_info("connect phase","Hello world", UVM_MEDIUM)

    channel_0.rx_agent.monitor.item_collected_port.connect(scoreboard.channel_0_packet);
    channel_1.rx_agent.monitor.item_collected_port.connect(scoreboard.channel_1_packet);
    channel_2.rx_agent.monitor.item_collected_port.connect(scoreboard.channel_2_packet);

    `uvm_info("CONNECT_DBG", $sformatf("environment.agent: %p", environment.agent), UVM_MEDIUM)
    `uvm_info("CONNECT_DBG", $sformatf("environment.agent.monitor: %p", environment.agent.monitor), UVM_MEDIUM)


    endfunction

endclass: router_tb