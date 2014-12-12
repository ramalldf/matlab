%Remove low lifetime data
%%=Fit double gaussian=
vectorlife = thrLife2(:);
noNan1 = vectorlife(~isnan(vectorlife));
edges= [0:100:10000];
[x,y]= histc(noNan,edges);
plot(edges,x)
fit2Gauss= fit(edges',x,'gauss2')
coeffs= coeffvalues(fit2Gauss);
amp1= coeffs(1);
mu1= coeffs(2);
std1= coeffs(3);
amp2= coeffs(4);
mu2= coeffs(5);
std2= coeffs(6);

plot(fit2Gauss)

%%=Calc. probabilities for each pixel=
tryprob = normpdf(noNan1, 1681, 258.8);
binprob = tryprob./(tryprob+tryprob2);
plot(binprob)
