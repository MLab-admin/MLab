classdef MLab < ML.Search.Root

    properties (Access = public)
       
        Plugins = {}
        Tutorials = {}
        
    end
    
    methods
        
        % --- Constructor -------------------------------------------------
        function this = MLab()
            
            % Get fullpath
            conf = ML.config;
            
            % --- Parent's constructor ------------------------------------
            
            this = this@ML.Search.Root(conf.path, 'info', struct('category', 'MLab'));
            
            % --- Installed plugins
            tmp = ML.dir([conf.path 'Plugins']);
            this.Plugins = {tmp(:).name};
            
            % --- Tutorials
                  
        end
        
    end
end