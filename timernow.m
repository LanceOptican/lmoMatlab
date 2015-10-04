% timernow -- call to read a clock timer

global timer_start
if isempty(timer_start)
    disp('No timers running');
    return
end
timer_end = clock;
timer_0 = timer_start(1, :);
timerprint('elapsed time so far: ', etime(timer_end, timer_0));
