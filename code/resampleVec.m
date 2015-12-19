function newvector=resampleVec(vector,newlen)
%%%%%%%%%%%%%%%%%%%%
%This function uses linear interpolation to change the number of samples
%%%%%%%%%%%%%%%%%%%%
len=length(vector);
x=1:len;x=x';y=vector;
xx=1:(len-1)/(newlen-1):len;
xx=xx';
yy=interp1(x,y,xx,'linear');
newvector=yy;
end