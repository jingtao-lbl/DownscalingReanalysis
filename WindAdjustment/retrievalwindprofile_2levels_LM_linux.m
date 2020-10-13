function [h,ustarKap,status]=retrievalwindprofile_2levels_LM_linux(Upro,Hpro,zz)
% Upro: known wind speeds at multiple levels (i.e., 10m, 30m, etc.);zz:surface roughness length
% To retrieve displacement height and friction velocity, given a known wind profile
% including at least two known wind speeds at two levels.
% -------------------------------------------------------------------------
% By Jing Tao, Duke University
% Last updated: 10/10/2013
% -------------------------------------------------------------------------

global U1 U2 z0 Z1 Z2
z0=zz;
h=NaN;ustarKap=NaN;
U1=Upro(1);U2=Upro(2);Z1=Hpro(1);Z2=Hpro(2);
if (isnan(U1)==0&&isnan(U2)==0)&&(U2>U1)
% ---------------------------------Not working in new version of matlab
% options = optimset('Algorithm','Levenberg-Marquardt','MaxFunEvals',100,'TolX',1e-4,'Display','off');
% [h,resnorm,residual,exitflag] = lsqnonlin(@myfun,0.1,[],[],options);if(h<0.01);h=0.01;elseif(h>Z1-1);h=Z1-1;end
% ---------------------------------
options = optimset('Algorithm','trust-region-reflective','MaxFunEvals',100,'TolX',1e-4,'Display','off');
[h,resnorm,residual,exitflag] = lsqnonlin(@myfun,0.1,0.01,Z1-1,options);
ustarKap = U1 / log( (Z1 - h) / z0 );
% ---------------------------------
% options = optimset('Algorithm','trust-region-reflective','MaxFunEvals',100,'TolX',1e-4,'Display','off');
% [ustarKap,resnorm,residual,exitflag] = lsqnonlin(@myfun,U1/2,0.0,min([U1,U2]),options);
% h=Z1-z0*exp(U1/ustarKap);
% ---------------------------------
status=exitflag;
else
    status=0.0;
end

end

% function fh=myfun(ustarKap)
% global U1 U2 z0 Z1 Z2
% fh=U2-ustarKap*log((Z2-Z1+z0*exp(U1/ustarKap))/z0);
% end

function fh=myfun(h)
global U1 U2 z0 Z1 Z2
fh=U2/U1-log((Z2-h)/z0)/log((Z1-h)/z0);
end
