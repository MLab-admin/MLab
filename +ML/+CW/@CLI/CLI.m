classdef CLI<handle
% ML.CW.CLI Command Line Interface
%   This class creates a text-input-based interface in the command window.
%   The interface has the form of several pages containing lists of 
%   options. At each step the user is asked to select an option and a
%   callback method is executed.
%
%   --- Syntax
%
%   ML.CW.CLI creates a CLI object. The default name of the first page is
%   'Main'.
%
%   ML.CW.CLI(PAGE) specifies the name of the first page.
%
%   --- Usage
%
%   The class ML.CW.CLI cannot be used directly, it has to be derived and
%   the 'define' method has to be overloaded to define the lists of page 
%   options. Then, the CLI can be instanciated and started with:
%
%       C = ML.CW.CLI;
%       C.start;
%
%   See also ML.CW.CLI
%
%   More on <a href="matlab:ML.doc('ML.CW.CLI');">ML.doc</a>

    % --- Properties
    properties (SetAccess = protected)
        
        message = '';
        header = '\n';
        page = '';
        elms = struct('key', {}, 'desc', {}, 'action', {});
        footer = '\n';
        
        case_sensitive = true;
        quit = false;
        output;
        
    end
    
    % --- Constructor
    methods
        
        function this = CLI(varargin)
            
            % --- Inputs
            in = ML.Input;
            in.page{'Main'} = @ischar;
            in = +in;
            
            % --- Definitions
            this.page = in.page;
            
        end
        
    end
end


%! ------------------------------------------------------------------------
%! Author: Raphaël Candelier
%! Version: 1.1
%
%! Revisions
%   1.1     (2015/04/07): Created help.
%   1.0     (2015/04/01): Initial version.
%
%! To_do
%   MLdoc
%! ------------------------------------------------------------------------
%! Doc
%   <title>To do</title>