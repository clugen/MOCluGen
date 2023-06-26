function mrgdata = clumerge(datasets, varargin)

    % Setup input validation
    p = inputParser;
    
    % Check that datasets is a cell with at least one dataset
    addRequired(p, 'datasets', @(x) iscell(x) && numel(x) > 0);
    
    % Check that fields is a cell with at least one field
    addParameter(p, 'fields', {'points', 'clusters'}, ...
        @(x) iscell(x) && numel(x) > 0);
    
    % Check that clusters_field is a string
    addParameter(p, 'clusters_field', 'clusters', @(x) isstring(x));
    
    % Check that output_type is either 'struct' or 'map'
    addParameter(p, 'output_type', 'struct', ...
        @(x) isstring(x) && any(validatestring(x, {'struct', 'map'})));

    % Perform input validation and parsing
    parse(p, datasets, varargin{:});
    
    % Number of elements in each array the merged dataset
    nelems = 0;

    % Contains information about each field
    fields_info = containers.Map();

    % Merged dataset to output, initially empty
    output = containers.Map();
    
    % Set of fields
    fields_set = p.Results.fields;
    
    % If the clusters_field parameter is given, make sure it exists in the
    % set of fields
    if (numel(p.Results.clusters_field) > 0) && ...
            ~any(ismember(fields_set, p.Results.clusters_field))
        fields_set = [fields_set, p.Results.clusters_field];
    end;
    
    % Cycle through data items
    for dt = datasets
        if iscell(dt{:})
            disp('is cell');
        else
            disp('is not cell');
        end;
    end;


end % function

% Copyright (c) 2012-2023 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)
