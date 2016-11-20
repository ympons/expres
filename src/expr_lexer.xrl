Definitions.

VAR   = ([A-Za-z_][0-9a-zA-Z_]*)
INT   = [0-9]+
FLOAT = ([0-9]+\.[0-9]*)
COMP  = (<|<=|=|>=|>)
ADD   = (\+|\-)
MULT  = (\*|/|mod)
STR   = '[^'\n]*'
WS    = ([\000-\s]|%.*)

Rules.

in      : {token, {in_op,   TokenLine, list_to_atom(TokenChars)}}.
or      : {token, {or_op,   TokenLine, list_to_atom(TokenChars)}}.
and     : {token, {and_op,  TokenLine, list_to_atom(TokenChars)}}.
not     : {token, {not_op,  TokenLine, list_to_atom(TokenChars)}}.
{COMP}  : {token, {comp_op, TokenLine, list_to_atom(TokenChars)}}.
{ADD}   : {token, {add_op,  TokenLine, list_to_atom(TokenChars)}}.
{MULT}  : {token, {mult_op, TokenLine, list_to_atom(TokenChars)}}.
{VAR}   : {token, {var,     TokenLine, list_to_atom(TokenChars)}}.
{STR}   : {token, {string,  TokenLine, strip(TokenChars, TokenLen)}}.
{INT}   : {token, {int,     TokenLine, list_to_integer(TokenChars)}}.
{FLOAT} : {token, {float,   TokenLine, list_to_float(TokenChars)}}.
[(),]   : {token, {list_to_atom(TokenChars), TokenLine}}.
{WS}+   : skip_token.

Erlang code.

strip(TokenChars,TokenLen) ->
    lists:sublist(TokenChars, 2, TokenLen - 2).