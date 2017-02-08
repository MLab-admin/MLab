classdef CLI<ML.CW.CLI
% ML.Updates.CLI MLab update CLI
%   This class creates a CLI to manage updates.
%
%   --- Syntax
%
%   ML.Updates.CLI creates a CLI object.
%
%   --- Usage
%
%   The following methods can be used to place a new element in the grid:
%       - <a href="matlab: help ML.CW.CLI.text">text</a>:   adds a textual element (not interactive)
%       - <a href="matlab: help ML.CW.CLI.select">select</a>: adds a selectable element. It supports multiple choices
%                 and multiple selections.
%       - <a href="matlab: help ML.CW.CLI.input">input</a>:  adds an input field
%       - <a href="matlab: help ML.CW.CLI.action">action</a>: adds an action (link)
%
%   Once all elements are placed on the grid, use the <a href="matlab: help ML.CW.CLI.print">print</a> method to 
%   display the interface.
%
%   See also ML.CW.CLI
%
%   More on <a href="matlab:ML.doc('ML.Updates.CLI');">ML.doc</a>


    % --- Properties
    properties (SetAccess = public)
        list = {};
    end
    
    % --- Constructor
    methods
        
        function this = CLI(varargin)
        
            this = this@ML.CW.CLI(varargin{:});
            
        end
        
    end
end