%{
#include <stdio.h>
#include <stdlib.h>
#include <map>
#include <string>
#include<string.h>
#include<iostream>

int yylex();
void yyerror(const char* s);

std::string type_string;
extern std::string identifier;
bool is_array = false;
%}

%union {
}

/* Keep all original tokens and add your specific ones */
%token IDENTIFIER CONSTANT STRING
%token CHARACTER_CONSTANT CHAR_ARR  /* Your additional constant types */
%token INT LONG UNSIGNED SIGNED DOUBLE CHAR VOID STRUCT 
%token STATIC EXTERN AUTO REGISTER TYPEDEF CONST VOLATILE
%token RETURN IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK
%token SIZEOF ENUM UNION CASE DEFAULT ELLIPSIS
%token OPEN_PARANTHESES CLOSE_PARANTHESES OPEN_BRACE CLOSE_BRACE
%token OPEN_BRACKET CLOSE_BRACKET
%token SEMICOLON COLON COMMA QUESTION_MARK
%token DOT ARROW_OPERATOR  /* Your ARROW_OPERATOR */
%token TILDE HYPHEN PLUS ASTERISK FORWARD_SLASH PERCENT_SIGN
%token AAND PIPE CARET  /* Original bitwise operators kept */
%token INCREMENT_OPERATOR DECREMENT_OPERATOR  /* Your increment/decrement */
%token LEFT_SHIFT RIGHT_SHIFT
%token ASSIGNMENT
%token COMPOUND_SUM COMPOUND_DIFFERENCE COMPOUND_PRODUCT COMPOUND_DIVISION
%token COMPOUND_REMAINDER COMPOUND_LEFTSHIFT COMPOUND_RIGHTSHIFT
%token COMPOUND_AND COMPOUND_XOR COMPOUND_OR
%token NOT LAND LOR
%token EQUAL NOTEQUAL LESSTHAN GREATERTHAN LESSTHANEQUAL GREATERTHANEQUAL


%precedence THEN
%precedence ELSE

%start translation_unit

%%

//expressions are ok and don't rquire any propagation for now
primary_exp
    : IDENTIFIER
    | CONSTANT
    | CHARACTER_CONSTANT 
    | CHAR_ARR          
    | STRING
    | OPEN_PARANTHESES exp CLOSE_PARANTHESES
    ;

postfix_exp
    : primary_exp
    | postfix_exp OPEN_BRACKET exp CLOSE_BRACKET
    | postfix_exp OPEN_PARANTHESES CLOSE_PARANTHESES
    | postfix_exp OPEN_PARANTHESES argument_exp_list CLOSE_PARANTHESES
    | postfix_exp DOT IDENTIFIER
    | postfix_exp ARROW_OPERATOR IDENTIFIER
    | postfix_exp INCREMENT_OPERATOR
    | postfix_exp DECREMENT_OPERATOR
    ;

argument_exp_list
    : assignment_exp
    | argument_exp_list COMMA assignment_exp
    ;

unary_exp
    : postfix_exp
    | INCREMENT_OPERATOR unary_exp
    | DECREMENT_OPERATOR unary_exp
    | unary_operator cast_exp
    | SIZEOF unary_exp
    | SIZEOF OPEN_PARANTHESES type_name CLOSE_PARANTHESES
    ;

unary_operator
    : AAND
    | ASTERISK
    | PLUS
    | HYPHEN
    | TILDE
    | NOT
    ;

cast_exp
    : unary_exp
    | OPEN_PARANTHESES type_name CLOSE_PARANTHESES cast_exp
    ;

multiplicative_exp
    : cast_exp
    | multiplicative_exp ASTERISK cast_exp
    | multiplicative_exp FORWARD_SLASH cast_exp
    | multiplicative_exp PERCENT_SIGN cast_exp
    ;

additive_exp
    : multiplicative_exp
    | additive_exp PLUS multiplicative_exp
    | additive_exp HYPHEN multiplicative_exp
    ;

shift_exp
    : additive_exp
    | shift_exp LEFT_SHIFT additive_exp
    | shift_exp RIGHT_SHIFT additive_exp
    ;

relational_exp
    : shift_exp
    | relational_exp LESSTHAN shift_exp
    | relational_exp GREATERTHAN shift_exp
    | relational_exp LESSTHANEQUAL shift_exp
    | relational_exp GREATERTHANEQUAL shift_exp
    ;

equality_exp
    : relational_exp
    | equality_exp EQUAL relational_exp
    | equality_exp NOTEQUAL relational_exp
    ;

and_exp
    : equality_exp
    | and_exp AAND equality_exp
    ;

exclusive_or_exp
    : and_exp
    | exclusive_or_exp CARET and_exp
    ;

inclusive_or_exp
    : exclusive_or_exp
    | inclusive_or_exp PIPE exclusive_or_exp
    ;

logical_and_exp
    : inclusive_or_exp
    | logical_and_exp LAND inclusive_or_exp
    ;

logical_or_exp
    : logical_and_exp
    | logical_or_exp LOR logical_and_exp
    ;

conditional_exp
    : logical_or_exp
    | logical_or_exp QUESTION_MARK exp COLON conditional_exp
    ;

assignment_exp
    : conditional_exp
    | unary_exp assignment_operator assignment_exp
    ;

assignment_operator
    : ASSIGNMENT
    | COMPOUND_SUM
    | COMPOUND_DIFFERENCE
    | COMPOUND_PRODUCT
    | COMPOUND_DIVISION
    | COMPOUND_REMAINDER
    | COMPOUND_LEFTSHIFT
    | COMPOUND_RIGHTSHIFT
    | COMPOUND_AND
    | COMPOUND_XOR
    | COMPOUND_OR
    ;

exp
    : assignment_exp
    | exp COMMA assignment_exp
    ;

constant_exp
    : conditional_exp
    ;
// it's just expression till here

//the first rule is int;[which is valid] so does not make sense to even keep an account of type
declaration
    : declaration_specifiers SEMICOLON
    | declaration_specifiers init_declarator_list SEMICOLON
    {
        //done processing the declaration list
        type_string = "";
    }
    ;

declaration_specifiers
    : storage_class_specifier
    | storage_class_specifier declaration_specifiers
    | type_specifier
    | type_specifier declaration_specifiers
    | type_qualifier
    | type_qualifier declaration_specifiers
    ;

init_declarator_list
    : init_declarator
    | init_declarator_list COMMA init_declarator
    ;

init_declarator
    : declarator
    | declarator ASSIGNMENT initializer
    ;

storage_class_specifier
    : TYPEDEF{type_string += " typedef";}
    | EXTERN{type_string += " extern";}
    | STATIC{type_string += " static"; }
    | AUTO{type_string += " auto";}
    | REGISTER{type_string += " register";}
    ;

type_specifier
    : VOID{type_string += " void";}
    | CHAR{type_string += " char";}
    | INT{type_string += " int";}
    | LONG{type_string += " long";}
    | SIGNED{type_string += " signed";}
    | UNSIGNED{type_string += " unsigned";}
    | DOUBLE{type_string += " double";}
    | struct_or_union_specifier
    | enum_specifier
    ;

struct_or_union_specifier
    : struct_or_union IDENTIFIER 
    {
        std::cout<<"struct"<<" , "<<identifier<<std::endl;
    }
    OPEN_BRACE struct_declaration_list CLOSE_BRACE
    | struct_or_union OPEN_BRACE struct_declaration_list CLOSE_BRACE 
    | struct_or_union IDENTIFIER
    {
       std::cout<<"struct"<<" , "<<identifier<<std::endl;
    }
    ;

struct_or_union
    : STRUCT
    | UNION
    ;

struct_declaration_list
    : struct_declaration
    | struct_declaration_list struct_declaration
    ;

struct_declaration
    : specifier_qualifier_list struct_declarator_list SEMICOLON
    {
        type_string = "";
    }
    ;

specifier_qualifier_list
    : type_specifier specifier_qualifier_list
    | type_specifier
    | type_qualifier specifier_qualifier_list
    | type_qualifier
    ;

struct_declarator_list
    : struct_declarator
    | struct_declarator_list COMMA struct_declarator
    ;

struct_declarator
    : declarator
    | COLON constant_exp
    | declarator COLON constant_exp
    ;

enum_specifier
    : ENUM OPEN_BRACE enumerator_list CLOSE_BRACE
    | ENUM IDENTIFIER OPEN_BRACE enumerator_list CLOSE_BRACE
    | ENUM IDENTIFIER
    ;

enumerator_list
    : enumerator
    | enumerator_list COMMA enumerator
    ;

enumerator
    : IDENTIFIER
    | IDENTIFIER ASSIGNMENT constant_exp
    ;

type_qualifier
    : CONST
    | VOLATILE
    ;

declarator
    : pointer direct_declarator
    | direct_declarator
    ;

direct_declarator
    : IDENTIFIER
    {
       std::cout<<type_string<<" , "<<identifier<<std::endl;
    }
    | OPEN_PARANTHESES declarator CLOSE_PARANTHESES
    {
        type_string = "";
    }
    | direct_declarator OPEN_BRACKET constant_exp CLOSE_BRACKET
    {
        std::cout<<"arrey vo array thi"<<std::endl;
    }
    | direct_declarator OPEN_BRACKET CLOSE_BRACKET
    | direct_declarator OPEN_PARANTHESES {
        std::cout<<"arrey vo function tha"<<std::endl;
        type_string = "";
    } parameter_type_list CLOSE_PARANTHESES{
       type_string = "";
    }
    | direct_declarator OPEN_PARANTHESES identifier_list CLOSE_PARANTHESES
    {
       type_string = "";
    }
    | direct_declarator OPEN_PARANTHESES CLOSE_PARANTHESES
    {
       type_string = "";
    }
    ;

pointer
    : ASTERISK{type_string+= " pointer";}
    | ASTERISK type_qualifier_list{type_string+= " pointer";}
    | ASTERISK pointer{type_string+= " pointer";}
    | ASTERISK type_qualifier_list pointer{type_string+= " pointer";}
    ;

type_qualifier_list
    : type_qualifier
    | type_qualifier_list type_qualifier
    ;

parameter_type_list
    : parameter_list
    | parameter_list COMMA ELLIPSIS
    ;

parameter_list
    : parameter_declaration
    | parameter_list COMMA{
       type_string = "";
    } parameter_declaration
    ;

parameter_declaration
    : declaration_specifiers declarator
    | declaration_specifiers abstract_declarator
    | declaration_specifiers
    ;

identifier_list
    : IDENTIFIER
    | identifier_list COMMA IDENTIFIER
    ;

type_name
    : specifier_qualifier_list
    | specifier_qualifier_list abstract_declarator
    ;

abstract_declarator
    : pointer
    | direct_abstract_declarator
    | pointer direct_abstract_declarator
    ;

direct_abstract_declarator
    : OPEN_PARANTHESES abstract_declarator CLOSE_PARANTHESES
    | OPEN_BRACKET CLOSE_BRACKET
    | OPEN_BRACKET constant_exp CLOSE_BRACKET
    | direct_abstract_declarator OPEN_BRACKET CLOSE_BRACKET
    | direct_abstract_declarator OPEN_BRACKET constant_exp CLOSE_BRACKET
    | OPEN_PARANTHESES CLOSE_PARANTHESES
    | OPEN_PARANTHESES parameter_type_list CLOSE_PARANTHESES
    | direct_abstract_declarator OPEN_PARANTHESES CLOSE_PARANTHESES
    | direct_abstract_declarator OPEN_PARANTHESES parameter_type_list CLOSE_PARANTHESES
    ;

initializer
    : assignment_exp
    | OPEN_BRACE initializer_list CLOSE_BRACE
    | OPEN_BRACE initializer_list COMMA CLOSE_BRACE
    ;

initializer_list
    : initializer
    | initializer_list COMMA initializer
    ;

statement
    : labeled_statement
    | compound_statement
    | expression_statement
    | selection_statement
    | iteration_statement
    | jump_statement
    | declaration
    | error {yyerrok;}
    ;

labeled_statement
    : IDENTIFIER COLON statement
    | CASE constant_exp COLON statement
    | DEFAULT COLON statement
    ;

compound_statement
    : OPEN_BRACE CLOSE_BRACE
    | OPEN_BRACE statement_list CLOSE_BRACE
    ;

declaration_list
    : declaration
    | declaration_list declaration
    ;

statement_list
    : statement
    | statement_list statement
    ;

expression_statement
    : SEMICOLON
    | exp SEMICOLON
    ;

selection_statement
    : IF OPEN_PARANTHESES exp CLOSE_PARANTHESES statement %prec THEN
    | IF OPEN_PARANTHESES exp CLOSE_PARANTHESES statement ELSE statement
    | SWITCH OPEN_PARANTHESES exp CLOSE_PARANTHESES statement
    ;

iteration_statement
    : WHILE OPEN_PARANTHESES exp CLOSE_PARANTHESES statement
    | DO statement WHILE OPEN_PARANTHESES exp CLOSE_PARANTHESES SEMICOLON
    | FOR OPEN_PARANTHESES expression_statement expression_statement CLOSE_PARANTHESES statement
    | FOR OPEN_PARANTHESES declaration expression_statement CLOSE_PARANTHESES statement
    | FOR OPEN_PARANTHESES expression_statement expression_statement exp CLOSE_PARANTHESES statement
    | FOR OPEN_PARANTHESES declaration expression_statement exp CLOSE_PARANTHESES statement
    ;

jump_statement
    : GOTO IDENTIFIER SEMICOLON
    | CONTINUE SEMICOLON
    | BREAK SEMICOLON
    | RETURN SEMICOLON
    | RETURN exp SEMICOLON
    ;

translation_unit
    : external_declaration
    | translation_unit external_declaration
    ;

external_declaration
    : function_definition
    | declaration
    ;

function_definition
    : declaration_specifiers declarator declaration_list compound_statement
    | declaration_specifiers declarator compound_statement
    | declarator declaration_list compound_statement
    | declarator compound_statement
    ;

%%