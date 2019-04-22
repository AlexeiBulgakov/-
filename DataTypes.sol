pragma solidity >= 0.4.0 < 0.6.0;

library DT {
    
    struct DateTime {
        uint8 yyyy;         //year
        uint8 mm;           //month
        uint8 dd;           //day
        uint8 hh;           //hour
        uint8 m;            //minute
        uint8 s;            //seconds
    }
    
}//DT (Data types)

library SCC {
    
    enum SCCStatus {
        anable_load,        //good work
        enable_overload,    //critical CPU or RAM parameters
        enable_crash,       //can't working
        not_enable,         //can't ping
        not_info            //without actual information
    }
    
    struct SCCStat {
        DT.DateTime dt;     //update date
        SCCStatus stat;     //currently SCC status
    }
    
    struct SCCInfo {
        DT.DateTime dt;     //update date
        string name;        //name
        string addr;        //address
        string desc;        //description
        uint32 cCNs;        //count of Computing Node
    }
    
}//SCC (Super Computer Center)

library CN {
    
    enum CNStatus {
        anable_load,        //good work
        enable_overload,    //critical CPU or RAM parameters
        enable_crash,       //can't working
        not_enable,         //can't ping
        not_info            //without actual information
    }
    
    struct CNStat {
        DT.DateTime dt;     //update date
        CNStatus stat;      //currently CN status
    }
    
    struct CNInfo {
        DT.DateTime dt;     //update date
        address owner;      //SCC-owner
        string name;        //name
        string host;        //IP-address
        string port;        //TCP-port
        uint32 cCMs;        //count of Computing Module
    }
    
}//CN (Computing node)

library CM {
    
    enum CMStatus {
        anable_load,        //good work
        enable_overload,    //critical CPU or RAM parameters
        enable_crash,       //can't working
        not_enable,         //can't ping
        not_info            //without actual information
    }
    
    struct CMStat {
        DT.DateTime dt;     //update date
        uint8 CPU;          //currently CPU load
        uint8 RAM;          //currently RAM load
        uint8 SDD;          //currently SDD load
        uint8 NET;          //currently NET load
        CMStatus stat;      //currently CM status
    }
    
    struct CMInfo {
        DT.DateTime dt;     //update date
        address owner;      //CN-owner
        string CPU_info;    //CPU apparate state description
        string RAM_info;    //RAM apparate state description
        string SDD_info;    //SDD apparate state description
        string NET_info;    //NET apparate state description
    }
    
}//CM (Computing Module)

library U {
    
    enum UserTyps {
        sys,                //SCC-admin
        adm,                //CN-admin
        usr,                //CN-user
        not_info            //without actual information
    }
    
    enum UserActs {
        add_task_usr,       //add new user's task by user
        rm_task_usr,        //remove new user's task by user (owner)
        rm_task_adm,        //remove new user's task by CN-admin
        rm_task_sys,        //remove new user's task by SCC-admin
        log_in,             //log in SCC
        log_out,            //out log from SCC
        creation,           //created new user-accaunt
        delleted,           //deleted existantly user-accaunt
        not_info            //without actual information
    }
    
    struct UserT {
        DT.DateTime dt;     //update date
        UserTyps typ;       //current user's type
    }
    
    struct UserA {
        DT.DateTime dt;     //update date
        UserActs act;       //last fixed action
    }
    
    struct UserI {
        string login;       //SCC-login
        string description; //user's info
    }
    
}//U (RAN's user)

library T {

    enum TState {
        initial,            //initial of task
        GQT_push,           //push task in GQT
        GQT_pop,            //pup task from GOT
        LQT_push,           //push task in LQT
        LQP_pop,            //pop task from LQT
        LQT_add,            //add task in stack of execution
        LQT_rm,             //remove task from stack of execution
        LQT_start_load,     //start copy of task data to LQT
        LQT_stop_load,      //stop copy of task data to LQT
        alloc_res,          //alloc the ressurses to task execution
        releas_res,         //release the ressurses of task
        not_info            //without actual information
    }
    
    struct TStatus {
        DT.DateTime dt;     //update date
        TState st;          //current task's status
    }
    
    struct TInfo {
        address owner;      //task's owner
        string  name;       //task's name
        uint32  nproc;      //count of proccessors for execution task
        uint32  p_coast;    //previously computing cost of the task
        uint32  f_coast;    //factualy computing cost of the task
    }
    
}//E (RAN's task)
