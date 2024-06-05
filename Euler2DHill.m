%solution domain
nx = 300;
ny = 60;
dx = 1;
dy = 1;
dt = 0.01;
nt = 10000;  
sol = zeros(nt,nx,ny,3);



%initial condition
sol(1,:,:,1) = 1;

%boundary conditions (if there are permanent ones)
sol(:,1,:,2) = 5;

sol(:,1,:,1) = 1;
sol(:,nx,:,1) = 1;
sol(:,:,1,1) = 1;
sol(:,:,ny,1) = 1;

%goal: At the end should have zero derriviative
%driven by velocity and not density 
%Top is straight forward, just zero derriviative 
%Bottom needs to be reflective in y direction

%boundary condition update 2
sol(1, nx, :, :) = sol(1, nx-1, :, :); %zero slope condition end
sol(1, :, ny, :) = sol(1, :, ny-1, :); %zero slope condition top

sol(1, :, 1, 1) = sol(1, :, 2, 1); %bottom p 
sol(1, :, 1, 2) = sol(1, :, 2, 2); %bottom u 
sol(1, :, 1, 3) = -sol(1, :, 2, 3); %bottom v 

%sets the front boundary condition
for i=1:nx
    for j=1:ny
        if (j <= cast(20*exp(-0.005*((i-75)^2)),"uint8")) 
            if i < 75
                sol(1,i,j,1) = sol(1,i-1,j,1);
                sol(1,i,j,2) = -sol(1,i-1,j,2);
                sol(1,i,j,3) = sol(1,i-1,j,3);
            else
                sol(1,i,j,1) = sol(1,i+1,j,1);
                sol(1,i,j,2) = -sol(1,i+1,j,2);
                sol(1,i,j,3) = sol(1,i+1,j,3);
            end
       end
    end
end

t = 2; 

while t <= nt
    
    %set up the boundary conditions for the edges here?

    %x-direction
    for i=2:nx-1
        for j=2:ny-1

            %need to doge some points 
            if (j <= cast(20*exp(-0.005*((i-75)^2)),"uint8"))
                continue;
            end
                   
            UR = reshape(sol(t-1,i+1,j,:),[3,1]);
            UL = reshape(sol(t-1,i-1,j,:),[3,1]);
            s = UR + UL;

            FR = fluxX(UR);
            FL = fluxX(UL);

            sf = FR - FL;

            sol(t,i,j,:) = 0.5*s - (dt/(2*dx))*(sf);
           
        end
    end

    
    t = t + 1; 

    %boundary condition update 2
    sol(t-1, nx, :, :) = sol(t-1, nx-1, :, :); %zero slope condition
    sol(t-1, :, ny, :) = sol(t-1, :, ny-1, :); %zero slope condition

    sol(t-1, :, 1, 1) = sol(t-1, :, 2, 1); %bottom p 
    sol(t-1, :, 1, 2) = sol(t-1, :, 2, 2); %bottom u 
    sol(t-1, :, 1, 3) = -sol(t-1, :, 2, 3); %bottom v 
    
    %sets the top boundary condition
    for i=1:nx
        for j=1:ny
            if (j == cast(20*exp(-0.005*((i-75)^2)),"uint8")) 
                sol(t-1,i,j,1) = sol(t-1,i,j+1,1);
                sol(t-1,i,j,2) = sol(t-1,i,j+1,2);
                sol(t-1,i,j,3) = -sol(t-1,i,j+1,3);
           end
        end
    end

    %y-direction
    for i=2:nx-1
        for j=2:ny-1

            %need to doge some points 
            if (j <= cast(20*exp(-0.005*((i-75)^2)),"uint8"))
                continue;
            end
                   
            UN = reshape(sol(t-1,i,j+1,:),[3,1]);
            US = reshape(sol(t-1,i,j-1,:),[3,1]);
            s = UN + US;

            FN = fluxY(UN);
            FS = fluxY(US);

            sf = FN - FS;

            sol(t,i,j,:) = 0.5*s - (dt/(2*dy))*(sf);

        end
    end
    
    t = t + 1; 
    %try to update within the loop to allow for fast parralelization

    %boundary condition update 1
    sol(t-1, nx, :, :) = sol(t-1, nx-1, :, :); %zero slope condition
    sol(t-1, :, ny, :) = sol(t-1, :, ny-1, :); %zero slope condition

    sol(t-1, :, 1, 1) = sol(t-1, :, 2, 1); %bottom p 
    sol(t-1, :, 1, 2) = sol(t-1, :, 2, 2); %bottom u 
    sol(t-1, :, 1, 3) = -sol(t-1, :, 2, 3); %bottom v 

    %sets the front boundary condition
    for i=1:nx
        for j=1:ny
            if (j <= cast(20*exp(-0.005*((i-75)^2)),"uint8")) 
                if i < 75
                    sol(t-1,i,j,1) = sol(t-1,i-1,j,1);
                    sol(t-1,i,j,2) = -sol(t-1,i-1,j,2);
                    sol(1,i,j,3) = sol(t-1,i-1,j,3);
                else
                    sol(t-1,i,j,1) = sol(t-1,i+1,j,1);
                    sol(t-1,i,j,2) = -sol(t-1,i+1,j,2);
                    sol(t-1,i,j,3) = sol(t-1,i+1,j,3);
                end
           end
        end
    end

end

function [f] = fluxX(U)
    p = U(1);
    pu = U(2);
    pv = U(3);
    
    f = [pu; (pu*pu/p) + 100*p; pu*pv/p];
end 

function [f] = fluxY(U)
    p = U(1);
    pu = U(2);
    pv = U(3);
    
    f = [pv;  pu*pv/p ; (pv*pv/p) + 100*p];
end 

