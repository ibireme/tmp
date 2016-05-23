
#include <sys/sysctl.h>

/**
 Returns process startup time in UNIX timestamp (millisecond).
 Returns 0 if an error occurs.
 */
uint64_t get_current_process_startup_timestamp() {
    int mib[4];
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = getpid(); // current process id
    
    struct kinfo_proc info = {0};
    size_t size = sizeof(info);
    
    int result = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);
    if (result != 0) return 0; //error
    
    struct timeval *time = &info.kp_proc.p_un.__p_starttime;
    uint64_t ts = (time->tv_sec * (uint64_t)1000) + (time->tv_usec / 1000);
    return ts;
}

