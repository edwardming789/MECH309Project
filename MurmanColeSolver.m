function [phi,miu,A,errorlist,count] = MurmanColeSolver(phi,miu,A,a,b,c,d,e,g,error,errorlist,tol,Nx,Ny,gamma,dydx,dy,dx,count)
%% Question 1 Use the Gauss-Seidel method to solve the equation along each column
    while error > tol
        %lower boundary
        for i = 1:Nx
            phi(i,1) = phi(i+Nx,1) - Uinf * dydx(i) * dy;
        end

        % Calculate A & miu
        for j = 2:(Ny-1)
            for i = 2:(Nx-1)
                loc = (j-1) * Ny + i;
                A(loc,1) = (1 - Minf^2) - (gamma + 1) * Minf^2 ...
                    / Uinf * (phi(loc+1,1) - phi(loc-1,1) ) / ( 2 * dx);
                if A(loc,1) > 0
                    miu(loc,1) = 0;
                else
                    miu(loc,1) = 1;
                end
            end
        end
        % Storing phiOld for error computing
        phiOld = phi;
        % factor
        for j = 2:(Ny-1)
            for i = 3:(Nx-1)
                % Locating specific Phi position
                loc = (j-1) * Ny + i;
                % Coefficient of (i,j-1) 
                c(loc,1) = 1 / dy^2;
                % Coefficient of (i-2,j)
                g(loc,1) = miu(loc-1,1) * A(loc-1,1) / dx^2;
                % Coefficient of (i-1,j)
                d(loc,1) = (1-miu(loc,1)) * A(loc,1) / (dx)^2 ...
                    - 2 * miu(loc-1,1) * A(loc-1,1) / (dx)^2;
                % Coefficient of (i+1,j)
                e(loc,1) = (1-miu(loc,1)) * A(loc,1) / (dx)^2;
                % Coefficient of (i,j+1))
                b(loc,1) = 1 / dy^2;
                % Coefficient of (i,j)
                a(loc,1) = miu(loc-1,1) * A(loc-1,1) / (dx)^2 - ...
                    2 * ((1-miu(loc,1))*A(loc,1))/(dx)^2 - 2/(dy)^2;
                % Phi Computing
                phi(loc,1) = -(c(loc,1) * phi(loc-Nx,1) ...
                    + g(loc,1) * phi(loc-2,1) ...
                    + d(loc,1) * phi(loc-1,1) ...
                    + e(loc,1) * phi(loc+1,1) ...
                    + b(loc,1) * phi(loc+Nx,1) ...
                    ) ./ a(loc,1); 
            end
        end

        error = max(max(abs(phiOld - phi)));
        count = count + 1;
        errorlist (count) = error;
    end
end