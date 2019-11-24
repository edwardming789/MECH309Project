function [A, miu, cp] = CalA_Miu(phi, counter, Nx, Uinf, Minf, gamma, dx, dy,c)
    %A judgement   
    u_ = (phi(counter+1,1) - phi(counter-1,1))/(2*dx) ;
    v_ = (phi(counter+(Nx-3),1) - phi(counter-(Nx-3),1))/(2*dy);
    u = (u_ + Uinf);
    U = sqrt (u^2 + v_^2);
    m = U / c;
    if m > 1 % supersonic locally
        A = (1 - Minf)^ 2 - (gamma + 1) * Minf^2 / Uinf * (phi (counter,1) - phi (counter-2,1) ) / ( 2* dx);
    else % subsonic flow
        A = (1 - Minf)^ 2 - (gamma + 1) * Minf^2 / Uinf * (phi (counter+1,1) - phi (counter-1,1) ) / ( 2* dx);
    end

    if A > 0
        miu = 0;
    else
        miu = 1;
    end
    
    cp = -2 * u_/Uinf;

end 