% timerend -- call to end a clock timer

global timer_start

if (length(timer_start))
	timer_end = clock;
	timer_0 = timer_start(1, :);
	if (length(timer_start(:, 1)) > 1)
		timer_start = timer_start(2:end, :);
	else
		timer_start = [];
	end
	timerprint('elapsed time: ', etime(timer_end, timer_0));
else
	disp('No timers were started!');
end