classdef Package < ML.Search.Root

    properties (Access = public)
       
        Syntax
        Content = {}
        
    end
    
    methods
        
        % --- Constructor -------------------------------------------------
        function this = Package(varargin)
            
            % --- Parent's constructor ------------------------------------
            
            this = this@ML.Search.Root(varargin{:});
            
            % --- Inputs --------------------------------------------------

            in = ML.Input(varargin{2:end});
            in.info(struct()) = @isstruct;
            in = +in;
       
            % --- Name
            [~, tmp] = fileparts(this.Fullpath);
            this.Name = tmp(2:end);
            
            % --- Content
            tmp = ML.dir(this.Fullpath);
            this.Content = {tmp(:).name};
            
            % --- Syntax
            if isprop(this, 'Package')
                this.Syntax = [this.Package '.' this.Name];
            else
                this.Syntax = this.Name;
            end
                  
        end
        
    end
end