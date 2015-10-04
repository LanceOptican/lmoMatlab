subplot(5,2,1)
[n,x] = hist(log10(priorsamp));
bar(x,n/length(priorsamp))
text(-9, .8,'Prior Distribution')
axis([-10 0 0 1])

subplot(5,2,3)
[n,x] = hist(log10(pos1));
bar(x, n/length(pos1));
text(-9, .8, 'Posterior after 1st flight')
axis([-10 0 0 1])

subplot(5,2,5)
[n,x] = hist(log10(pos5));
bar(x,n/length(pos5));
axis([-10 0 0 1])
text(-9, .8, 'After 5th flight')
ylabel('Probability')

subplot(5,2,7)
[n,x] = hist(log10(pos10));
bar(x,n/length(pos10));
axis([-10 0 0 1])
text(-9, .8, 'After 10th flight')

subplot(5,2,9)
[n,x] = hist(log10(pos20));
bar(x, n/length(pos20));
axis([-10 0 0 1])
text(-9, .8, 'After 20th flight')
xlabel('Log of accident rate')
