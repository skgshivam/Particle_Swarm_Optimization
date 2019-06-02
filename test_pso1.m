clc;
clear;
close all;


    nVar = 2;        % Number of Unknown (Decision) Variables

    VarSize = [1 nVar];         % Matrix Size of Decision Variables

    VarMin = -10;	% Lower Bound of Decision Variables
    VarMax = 10;    % Upper Bound of Decision Variables


    %% Parameters of PSO

    MaxIt = 15;   % Maximum Number of Iterations

    nPop = 4;     % Population Size (Swarm Size)

    w = 1;           % Intertia Coefficient
    wdamp = 0.99;   % Damping Ratio of Inertia Coefficient
    c1 = 2;         % Personal Acceleration Coefficient
    c2 = 2;         % Social Acceleration Coefficient

    % The Flag for Showing Iteration Information
    
    MaxVelocity = 0.2*(VarMax-VarMin);
    MinVelocity = -MaxVelocity;
    labels = {'P1','P2','P3','P4'};
    %% Initialization

    % The Particle Template
    empty_particle.Position = [];
    empty_particle.Velocity = [];
    empty_particle.Cost = [];
    empty_particle.Best.Position = [];
    empty_particle.Best.Cost = [];
    empty_particle.Energy = [];
    empty_particle.Ch = [];
    empty_particle.Alive = [];
    % Create Population Array
    particle = repmat(empty_particle, nPop, 1);

    % Initialize Global Best
    GlobalBest.Cost = inf;
    c_i = 0;
    % Initialize Population Members
    for i=1:nPop

        % Generate Random Solution
        particle(i).Position = unifrnd(VarMin, VarMax, VarSize);
           particle(i).Alive = 1;
        % Initialize Velocity
        particle(i).Velocity = zeros(VarSize);
        particle(i).Energy = 30;
        particle(i).Ch = 0;
    end
    for i = 1:nPop
        % Evaluation
        
        particle(i).Cost = Cost_function(i,particle,nPop);

        % Update the Personal Best
        particle(i).Best.Position = particle(i).Position;
        particle(i).Best.Cost = particle(i).Cost;
        
        % Update Global Best
        if particle(i).Best.Cost < GlobalBest.Cost
            GlobalBest = particle(i).Best;
            c_i = i;
        end

    end
    %Update cluster head
        particle(c_i).ch = 1; 
    % Array to Hold Best Cost Value on Each Iteration
 BestCosts = zeros(MaxIt, 1);
 C_Energy = zeros(MaxIt, 1);
 y = [];
 x = [];
    for it=1:MaxIt
        c_new = c_i;
        for i=1:nPop
            %Energy dissipated by non cluster head nodes to send the sensor values and their positions 
            if particle(i).Ch == 0 && particle(i).Alive ==1
                distance = (particle(i).Position(1)-particle(c_i).Position(1)).*(particle(i).Position(1)-particle(c_i).Position(1));
                distance = distance + (particle(i).Position(2)-particle(c_i).Position(2)).*(particle(i).Position(2)-particle(c_i).Position(2));
                particle(i).Energy = particle(i).Energy - 0.01.*distance;
                if particle(i).Energy <=0
                    particle(i).Energy = 0;
                    particle(i).Alive = 0;
                end
            end
            
            %Energy dissipated by cluster head to base station
            if particle(i).Ch == 1 && particle(i).Alive ==1
                distance = (particle(i).Position(1)).*(particle(i).Position(1));
                distance = distance + (particle(i).Position(2)).*(particle(i).Position(2));
                particle(i).Energy = particle(i).Energy - 0.01.*distance;
                if particle(i).Energy <=0
                    particle(i).Energy = 0;
                    particle(i).Alive = 0;
                end
            end
            
        end
        for i=1:nPop
          if particle(i).Alive ==1
            % Update Velocity
            
            particle(i).Velocity = w*particle(i).Velocity ...
                + c1*rand(VarSize).*(particle(i).Best.Position - particle(i).Position) ...
                + c2*rand(VarSize).*(GlobalBest.Position - particle(i).Position);

            % Apply Velocity Limits
            particle(i).Velocity = max(particle(i).Velocity, MinVelocity);
            particle(i).Velocity = min(particle(i).Velocity, MaxVelocity);
            
            % Update Position
            particle(i).Position = particle(i).Position + particle(i).Velocity;
            
            % Apply Lower and Upper Bound Limits
            %particle(i).Position = max(particle(i).Position, VarMin);
            %particle(i).Position = min(particle(i).Position, VarMax);

            % Evaluation
            particle(i).Cost = Cost_function(i,particle,nPop);

            % Update Personal Best
            if particle(i).Cost < particle(i).Best.Cost

                particle(i).Best.Position = particle(i).Position;
                particle(i).Best.Cost = particle(i).Cost;

                % Update Global Best
                if particle(i).Best.Cost < GlobalBest.Cost
                    GlobalBest = particle(i).Best;
                    c_new = i;
                end            

            end
            y(i) = particle(i).Position(1);
            x(i) = particle(i).Position(2);
          end
        end
        %Energy dissipated by cluster head to all non cluster head nodes
                for j = 1:nPop
                    if particle(j).Alive ==1
                    distance = (particle(c_i).Position(1)-particle(j).Position(1)).*(particle(c_i).Position(1)-particle(j).Position(1));
                    distance = distance + (particle(c_i).Position(2)-particle(j).Position(2)).*(particle(c_i).Position(2)-particle(j).Position(2));
                    particle(c_i).Energy = particle(c_i).Energy - 0.01.*distance;
                    end
                    if particle(c_i).Energy <=0
                        particle(c_i).Energy=0;
                        particle(c_i).Alive = 0;
                    end
                end
        cls = zeros(1,nPop);
        cls(c_i)=1;
        c=zeros(nPop,3);
        c(cls==1,:)=[1 0 0]; % 1 is red
        % ...
        scatter(x,y,[],c);
        hold on
        scatter(20,20,'x')
        hold off
        text(x,y,labels,'VerticalAlignment','top','HorizontalAlignment','left')
        xlim([-50,50]);
        ylim([-50,50]);
        pause(2.5);
        
        if c_i~=c_new
            %Energy dissipated by new cluster head
                for j = 1:nPop
                    if particle(j).Alive ==1
                    distance = (particle(c_new).Position(1)-particle(j).Position(1)).*(particle(c_new).Position(1)-particle(j).Position(1));
                    distance = distance + (particle(c_new).Position(2)-particle(j).Position(2)).*(particle(c_new).Position(2)-particle(j).Position(2));
                    particle(c_new).Energy = particle(c_new).Energy - 0.01.*distance;
                    end
                end
                if particle(c_new).Energy <=0
                        particle(c_new).Energy=0;
                        particle(c_new).Alive = 0;
                end
            particle(c_i).Ch=0;
            particle(c_new).Ch=1;
            c_i = c_new;
        end
       
        % Store the Best Cost Value
        BestCosts(it) = GlobalBest.Cost;
        C_Energy(it) =0;
        for j=1:nPop
            C_Energy(it) = C_Energy(it) + particle(i).Energy;
        end
        if it > 1
            if C_Energy(it-1)-C_Energy(it)  > 15
                C_Energy(it) = C_Energy(it) + 10;
            end
        end
        % Display Iteration Informatio
        disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCosts(it)) ': Particle =' num2str(c_i)]);
        
        % Damping Inertia Coefficient
        w = w * wdamp;

    end
    
    plot([1:MaxIt],C_Energy);
    xlabel('No. of Iterations');
    ylabel('Total Energy of Cluster');
    