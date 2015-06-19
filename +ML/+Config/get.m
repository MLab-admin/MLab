function [config, fname] = get(varargin)
%ML.Config.get Get MLab configuration parameters
%   C = ML.Config.get() returns the main MLab configuration structure.
%
%   C = ML.Config.get(..., 'cfile', CFILE) returns the configuration
%   structure contained in the file tagged with CFILE in the PREFDIR
%   directory.
%
%   C = ML.Config.get(..., 'param', LIST) specifies the parameters (string
%   or cell of strings).
%
%   C = ML.Config.get(..., 'quiet', true) suppresses the error message if 
%   the configuration file does not exist.
%
%   See also ML.config
%
%   More on <a href="matlab:ML.doc('Config.get')">ML.doc</a>

% Input variables
in = ML.Input;
in.cfile('MLab') =  @ischar;
in.quiet(true) = @islogical;
in = +in;

% Build file name
fname = [prefdir filesep in.cfile '.mat'];

% Get config
if ~exist(fname, 'file')
    ML.Config.default('cfile', in.cfile, 'quiet', in.quiet);
end

tmp = load(fname);
config = tmp.config;