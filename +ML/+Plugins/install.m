function out = install(ptags, varargin)
%ML.Plugins.install Install plugins
%
%   See also ML.plugins.

% === Input variables =====================================================

in = ML.Input(ptags, varargin{:});
in.addRequired('ptags', @(x) ischar(x) || iscellstr(x));
in.addParamValue('rethrow', false, @islogical);
in = +in;

% =========================================================================

% --- Set the plugins tags cell
if ischar(in.ptags)
    in.ptags = {in.ptags};
end

% --- Get configuration structure
config = ML.Config.get;

% --- Get file list
url = [config.updates.mirror_url 'MLab.php?list='];
for i = 1:numel(in.ptags)
    if i>1, url = [url ',']; end
    url = [url in.ptags{i}];
end
tmp = ML.Internal.fetch(url, 'delimiter', {'\n','\r','\t'});
L = tmp(2:2:end);

if isempty(L)
    out = false;
    return
end

% --- Get user input
while true
    
    if numel(in.ptags)>1, s = 's'; else, s= ''; end
    fprintf('You are about to install %i plugin%s on this computer.\n\n', numel(in.ptags), s);
    fprintf('Do you want to proceed installation? [Y/n]\n');
    a = input('?> ', 's');
    
    switch lower(a)
        case 'n'
            fprintf('\nInstallation aborted.\n');
            out = false;
            return
            
        case {'', 'y'}
            break;
            
        otherwise
            clc
    end
end

% --- Installation
h = waitbar(0,'Installation ...');
for i = 1:numel(L)
    
    % Create subdirectory (if it does not exist)
    D = fileparts([config.path L{i}]);
    if ~exist(D, 'dir'), mkdir(D); end
    
    % Load file from server
    urlwrite([config.updates.mirror_url 'Code/' L{i}], ...
        [config.path L{i}], 'Charset', 'UTF-8');
    
    % Waitbar
    waitbar(i/numel(L));
end
close(h);

% --- Update path
addpath(genpath(config.path), '-end');

% --- Plugin startup
for i = 1:numel(in.ptags)
    try ML.(in.ptags{i}).startup; end
end

% --- Output
out = true;

sl = ''
for i = 1:numel(in.ptags)
    if i>1, sl = [sl ', ']; end
    sl = [sl in.ptags{i}];
end

if in.rethrow
    ML.plugins('message', ['Installation of ' sl ' successfull.']);
else
    fprintf('\nInstallation of %s successfull.\n\n', sl);
end

