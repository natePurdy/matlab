% decipher a hw problem for network class
close all; clear;

text = fileread('cipher.txt');

% see which letter occurs the most
% Keep only letters, make lowercase
letters = lower(text(isletter(text)));

% Get sorted unique letters
[uLetters, ~, idx] = unique(letters);


% Count occurrences
counts = accumarray(idx, 1);

% Convert to cell array of chars
uniqueCells = cellstr(uLetters(:));


% Combine letters + counts into a single cell array
letterCounts = [uniqueCells num2cell(counts)];

% FILL IN ANY MISSING LETTERS FOR SHIFINGS SAKE!!!


% shift the letters by the suspected shift amount based on where e is
%(one of the vowels is definately the higherst count, even if not first guess of e, there are only liek 4)

% Extract the numeric counts from column 2
allCounts = cell2mat(letterCounts(:,2));

% Find the index of the maximum count
[~, maxIdx] = max(allCounts);


% now find the shift between the max occuring letter and the letter e
alphabet = 'a':'z';
maxLetter = letterCounts{maxIdx,1};   % e.g. 't'
letterIndex = find(alphabet == maxLetter);  % correct index in alphabet
shift = letterIndex - 5;   % because 'e' is the 5th letter


% create the shifted alphabet for ease of the nex step
shiftedAlphabet = circshift(alphabet, shift);

% now replace all letters in the cipher text with their shifted counterpart

% go through alphabet and replac corresponding shifted alphabet into cipher
% text
text = lower(text);

for i=1: length(text)
    for k = 1:length(alphabet)
        if text(i) == string(alphabet(k))
            text(i) = string(shiftedAlphabet(k)); 
            break;
        end
    end
end
