function Z = GHz_convert(H,lat)
%----------------------------------------------------------------
%H-geopotential height
%lat-latitudes
%Convert geopotential height (H, in m) to elevations (Z).
%----------------------------------------------------------------
% By Jing Tao, Duke University
% Last updated: 08/31/2012
%----------------------------------------------------------------

s=size(H);
H=H(:);lat=lat(:);
phi=lat;%in radian
go = 9.80665;
g = 9.80616 * ( 1 - 0.002637*cos(2*phi) + 0.0000059*cos(2*phi).^2 );
G = g/go;
Re = 1000./(cos(phi).^2/6378.137^2 + sin(phi).^2/6356.752^2 ).^(0.5);
Z = H.*Re./( G.*Re - H );
Z=reshape(Z,s(1),s(2));

end
