classdef Class < ML.Search.Root

    properties (Access = public)
       
        Syntax
        
    end
    
    methods
        
        % --- Constructor -------------------------------------------------
        function this = Class(varargin)
            
            % --- Parent's constructor ------------------------------------
            
            this = this@ML.Search.Root(varargin{:});
            
            % --- Inputs --------------------------------------------------

            in = ML.Input(varargin{2:end});
            in.info(struct()) = @isstruct;
            in = +in;
            
            % --- Name
            [~, tmp] = fileparts(this.Fullpath);
            this.Name = tmp(2:end);
            
            % --- Syntax
            if isprop(this, 'Package')
                this.Syntax = [this.Package '.' this.Name];
            else
                this.Syntax = this.Name;
            end
                  
            % --- Parents
            tmp = superclasses(this.Syntax);
            if ~isempty(tmp)
                addprop(this, 'Parents');
                this.Parents = tmp;
            end
            
        end
        
    end
end