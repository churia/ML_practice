function [w,s,alpha,obj,cg]=NTLR(X,Y,C)
[l,n]=size(X);
%initialize w_0, eta, xi, C,epsilon
w(:,1)=zeros(n,1);eta=0.01;xi=0.1;epsilon=0.01;
%constant
stop=zeros(n,1);
k=1;%iteration count
tic;
while true
    XW=X*w(:,k);
    XWY=XW.*Y;
    sigmoid=1./(1+exp(-XWY));
    %gradient of f(w_k)
    tmp=C*sum(spdiags((sigmoid-1).*Y,0,l,l)*X);
    gradf_w=w(:,k)+reshape(tmp,n,1);
    if k==1
        stop=gradf_w;
    else
        %stop condition
        if norm(gradf_w)<=epsilon*norm(stop)
            break;
        end
    end
    %=============Newton iterations:============   
    %------------Newton linear system-----------
    %conjugate gradient
    %diagonal:
    D=spdiags(exp(-XWY).*sigmoid.*sigmoid,0,l,l);
    %initalize s0,r0,d
    si=zeros(n,1);r=-gradf_w;d=r;oldr=r;
    i=0;
    while norm(r)>xi*norm(gradf_w)
        %Hd=d+C*XT*();%hession-free
        A=D*(X*d);
        AT=reshape(A,1,l);
        ATX=AT*X;
        Hd=d+C*reshape(ATX,n,1);
        ai=sum(r.*r)/sum(d.*Hd);
        si=si+ai*d;
        r=r-ai*Hd;
        beta=sum(r.*r)/sum(oldr.*oldr);
        d=r+beta*d;
        oldr=r;
        i=i+1;
    end
    s(:,k)=si;
    cg(k)=i;
    %-----------------Line Search----------------
    a=1;
    %f(w_k)
    fwk=0.5*sum(w(:,k).*w(:,k))+C*sum(log(1+exp(-XWY)));
    eta_grad_w_sk=sum(gradf_w.*s(:,k))*eta;
    while true
        wkk=w(:,k)+a*s(:,k);
        XWW=XW+X*s(:,k)*a;%X*wkk;%
        %f(w_k+a*s_k)
        fwkk=0.5*sum(wkk.*wkk)+C*sum(log(1+exp(-XWW.*Y)));
        if fwkk<=fwk+a*eta_grad_w_sk
            obj(k)=fwkk;
            break;
        end
        a=a*0.5;
        if a==1/16
            break;
        end
    end
    alpha(k)=a;
    %-------------------Update---------------------
    w(:,k+1)=w(:,k)+alpha(k)*s(:,k);
    k=k+1;
end
toc;





