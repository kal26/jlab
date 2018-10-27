
function [x,y] = poissonsim(mean, tries)
%
% POISSON distribution generator
% function [x,y] = gen(mean, tries)
%
% mean = the mean of the POISSON distribution
% tries = number of times the data was taken
% x = the vector of simulated Poisson distribution -- which will be 
%     different everytime this generator is run
% y = the binned simulated Poisson distribution 
%
% This function plots errorbars only if mean <=10. Otherwise, plot
% gets to crowded. If you want to edit it, copy it and poisson.m to
% your home directory and change it. 

% first need to find the probability integral...

gran = 1;  % this is the granularity of the distribution
           % realistically set to 1 
m=0;
j = 0;
pset = 0:m;
pint = 0:m;
x = 0:j;
randpick = 0:m;
if (mean > 4) && (mean < 25)
   maxb = 4*ceil(mean);
else 
  if mean >= 25 
    maxb = 2.5*ceil(mean);
  else
    maxb = 16;
  end
end
    for i = 0:gran:maxb
       m = m + 1;
       pset(m) = poisson(i,mean);
       pint(m) = sum(pset(1:m))*gran;
     end
     i = 0:gran:maxb;
      bin = ones(maxb/gran+2,1)-1;

% generate set of totally random numbers
     for j = 1:tries
       randpick(j) = rand;
% now need to find which bins those random numbers correspond to
       tf = 0;
       k = 1;
       while tf == 0 
	 if randpick(j) < pint(k)
	   bin(k) = bin(k) + 1;
	   tf = 1;
	   x(j) = k-1;
	 else
	   k = k + 1;
% this bin is overflow
           if k > maxb/gran+1
	     bin(k) = bin(k) + 1;
	     tf = 1;
	     x(j) = k-1;
	   end
	 end
       end
     end

y = bin;

% now plot 
di = 0:gran/10:maxb;
%set(axes,'fontsize',14);
plot(di,poisson(di,mean)*tries*gran,'b-', 'linewidth',2)
hold on
plot(i,bin(1:length(bin)-1),'r.','markersize',20)
err = sqrt(bin(1:length(bin)-1));
if mean <=10
  errorbar(i,bin(1:length(bin)-1),err,'r.')
end
xlabel('Frequency bins','fontsize',16)
ylabel('Number of events','fontsize',16)
title('Poisson simulator','fontsize',18)
axis([0 maxb 0 1.5*tries*poisson(mean,mean)])
hold off
