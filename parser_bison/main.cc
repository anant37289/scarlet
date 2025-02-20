#include "parser.tab.c"
#include "symbol_table.h"
#include <iomanip>
#include <lexer/lexer.hh>
#include <map>
#include <memory>
#include <string>
#include <token/token.hh>
#include <tools/color/color.hh>

std::string identifier;

void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}

std::vector<scarlet::token::Token> tokens;
size_t current_token_index = 0;

void get_tokens(std::string file_path) {
  std::unique_ptr<scarlet::lexer::lexer> lexer =
      std::make_unique<scarlet::lexer::lexer>();
  lexer->set_file_path(std::move(file_path));
  lexer->tokenize();
  tokens = lexer->get_tokens();
  lexer->print_symbol_table();
}

int yylex() {
  // Check if we've processed all tokens
  if (current_token_index >= tokens.size()) {
    return 0; // Return 0 to indicate EOF
  }

  // Get current token
  scarlet::token::Token &current_token = tokens[current_token_index++];
  scarlet::token::TOKEN token_type = current_token.get_token();

  // Map your token types to Bison token types
  switch (token_type) {
  case scarlet::token::TOKEN::IDENTIFIER:
    identifier = current_token.get_value().value().c_str();
    identifier += "." + std::to_string(global_counter++);
    if (symbol_table.find(identifier) == symbol_table.end()) {
      symbol_table[identifier] = identifier_info();
    }
    return IDENTIFIER;
  case scarlet::token::TOKEN::CONSTANT:
    return CONSTANT;
    // case scarlet::token::TOKEN::STRING:
    return STRING;
  case scarlet::token::TOKEN::CHARACTER_CONSTANT:
    return CHARACTER_CONSTANT;
  case scarlet::token::TOKEN::CHAR_ARR:
    return CHAR_ARR;
  case scarlet::token::TOKEN::INT:
    return INT;
  case scarlet::token::TOKEN::LONG:
    return LONG;
  case scarlet::token::TOKEN::UNSIGNED:
    return UNSIGNED;
  case scarlet::token::TOKEN::SIGNED:
    return SIGNED;
    // case scarlet::token::TOKEN::DOUBLE:
    return DOUBLE;
  case scarlet::token::TOKEN::CHAR:
    return CHAR;
  case scarlet::token::TOKEN::VOID:
    return VOID;
  case scarlet::token::TOKEN::STRUCT:
    return STRUCT;
  case scarlet::token::TOKEN::STATIC:
    return STATIC;
  case scarlet::token::TOKEN::EXTERN:
    return EXTERN;
  // case scarlet::token::TOKEN::AUTO:
  //     return AUTO;
  // case scarlet::token::TOKEN::REGISTER:
  //     return REGISTER;
  // case scarlet::token::TOKEN::TYPEDEF:
  //     return TYPEDEF;
  // case scarlet::token::TOKEN::CONST:
  //     return CONST;
  // case scarlet::token::TOKEN::VOLATILE:
  //     return VOLATILE;
  case scarlet::token::TOKEN::RETURN:
    return RETURN;
  case scarlet::token::TOKEN::IF:
    return IF;
  case scarlet::token::TOKEN::ELSE:
    return ELSE;
    // case scarlet::token::TOKEN::SWITCH:
    return SWITCH;
  case scarlet::token::TOKEN::WHILE:
    return WHILE;
  case scarlet::token::TOKEN::DO:
    return DO;
  case scarlet::token::TOKEN::FOR:
    return FOR;
  case scarlet::token::TOKEN::GOTO:
    return GOTO;
  case scarlet::token::TOKEN::CONTINUE:
    return CONTINUE;
  case scarlet::token::TOKEN::BREAK:
    return BREAK;
  case scarlet::token::TOKEN::SIZEOF:
    return SIZEOF;
  // case scarlet::token::TOKEN::ENUM:
  //     return ENUM;
  // case scarlet::token::TOKEN::UNION:
  //     return UNION;
  // case scarlet::token::TOKEN::CASE:
  //     return CASE;
  // case scarlet::token::TOKEN::DEFAULT:
  //     return DEFAULT;
  // case scarlet::token::TOKEN::ELLIPSIS:
  //     return ELLIPSIS;
  case scarlet::token::TOKEN::OPEN_PARANTHESES:
    return OPEN_PARANTHESES;
  case scarlet::token::TOKEN::CLOSE_PARANTHESES:
    return CLOSE_PARANTHESES;
  case scarlet::token::TOKEN::OPEN_BRACE:
    return OPEN_BRACE;
  case scarlet::token::TOKEN::CLOSE_BRACE:
    return CLOSE_BRACE;
  case scarlet::token::TOKEN::OPEN_BRACKET:
    return OPEN_BRACKET;
  case scarlet::token::TOKEN::CLOSE_BRACKET:
    return CLOSE_BRACKET;
  case scarlet::token::TOKEN::SEMICOLON:
    return SEMICOLON;
  case scarlet::token::TOKEN::COLON:
    return COLON;
  case scarlet::token::TOKEN::COMMA:
    return COMMA;
  case scarlet::token::TOKEN::QUESTION_MARK:
    return QUESTION_MARK;
  case scarlet::token::TOKEN::DOT:
    return DOT;
  case scarlet::token::TOKEN::ARROW_OPERATOR:
    return ARROW_OPERATOR;
  case scarlet::token::TOKEN::TILDE:
    return TILDE;
  case scarlet::token::TOKEN::HYPHEN:
    return HYPHEN;
  case scarlet::token::TOKEN::PLUS:
    return PLUS;
  case scarlet::token::TOKEN::ASTERISK:
    return ASTERISK;
  case scarlet::token::TOKEN::FORWARD_SLASH:
    return FORWARD_SLASH;
  case scarlet::token::TOKEN::PERCENT_SIGN:
    return PERCENT_SIGN;
  case scarlet::token::TOKEN::AAND:
    return AAND;
  // case scarlet::token::TOKEN::PIPE:
  //     return PIPE;
  // case scarlet::token::TOKEN::CARET:
  //     return CARET;
  case scarlet::token::TOKEN::INCREMENT_OPERATOR:
    return INCREMENT_OPERATOR;
  case scarlet::token::TOKEN::DECREMENT_OPERATOR:
    return DECREMENT_OPERATOR;
  case scarlet::token::TOKEN::LEFT_SHIFT:
    return LEFT_SHIFT;
  case scarlet::token::TOKEN::RIGHT_SHIFT:
    return RIGHT_SHIFT;
  case scarlet::token::TOKEN::ASSIGNMENT:
    return ASSIGNMENT;
  case scarlet::token::TOKEN::COMPOUND_SUM:
    return COMPOUND_SUM;
  case scarlet::token::TOKEN::COMPOUND_DIFFERENCE:
    return COMPOUND_DIFFERENCE;
  case scarlet::token::TOKEN::COMPOUND_PRODUCT:
    return COMPOUND_PRODUCT;
  case scarlet::token::TOKEN::COMPOUND_DIVISION:
    return COMPOUND_DIVISION;
  case scarlet::token::TOKEN::COMPOUND_REMAINDER:
    return COMPOUND_REMAINDER;
  case scarlet::token::TOKEN::COMPOUND_LEFTSHIFT:
    return COMPOUND_LEFTSHIFT;
  case scarlet::token::TOKEN::COMPOUND_RIGHTSHIFT:
    return COMPOUND_RIGHTSHIFT;
  case scarlet::token::TOKEN::COMPOUND_AND:
    return COMPOUND_AND;
  case scarlet::token::TOKEN::COMPOUND_XOR:
    return COMPOUND_XOR;
  case scarlet::token::TOKEN::COMPOUND_OR:
    return COMPOUND_OR;
  case scarlet::token::TOKEN::NOT:
    return NOT;
  case scarlet::token::TOKEN::LAND:
    return LAND;
  case scarlet::token::TOKEN::LOR:
    return LOR;
  case scarlet::token::TOKEN::EQUAL:
    return EQUAL;
  case scarlet::token::TOKEN::NOTEQUAL:
    return NOTEQUAL;
  case scarlet::token::TOKEN::LESSTHAN:
    return LESSTHAN;
  case scarlet::token::TOKEN::GREATERTHAN:
    return GREATERTHAN;
  case scarlet::token::TOKEN::LESSTHANEQUAL:
    return LESSTHANEQUAL;
  case scarlet::token::TOKEN::GREATERTHANEQUAL:
    return GREATERTHANEQUAL;
  default:
    return -1;
  }
}
std::string to_original(std::string token_) {
  int pos_ = token_.find('.');
  token_ = token_.substr(0, pos_);
  return token_;
}

std::string to_unspecified(std::string token_) {
  return token_.empty() ? "UNSPECIFIED" : token_;
}

void print_symbol_table(std::map<std::string, identifier_info> &symbol_table) {
  const int w = 32;
  std::cout << BOLD << CYAN << std::left << std::string(3.5 * w, '-') << RESET
            << std::endl;
  std::cout << MAGENTA << std::string(1.5 * w, ' ') << "PARSER_SYMBOL_TABLE"
            << RESET << std::endl;
  std::cout << BOLD << CYAN << std::left << std::string(3.5 * w, '-') << RESET
            << std::endl;
  std::cout << YELLOW << std::left << std::setw(w) << "IDENTIFIER"
            << std::setw(w) << "STORAGE_CLASS" << std::setw(w) << "TYPE"
            << std::setw(w) << "USAGE" << RESET << std::endl;
  std::cout << BOLD << CYAN << std::left << std::string(3.5 * w, '-') << RESET
            << std::endl;
  for (auto &token_ : symbol_table) {
    if (token_.second.type.empty())
      continue;
    std::cout << RED << std::left << std::setw(w)
              << to_unspecified(to_original(token_.first)) << GREEN
              << std::setw(w) << to_unspecified(token_.second.storage_class)
              << std::setw(w) << to_unspecified(token_.second.type)
              << std::setw(w) << to_unspecified(token_.second.usage) << RESET
              << std::endl;
  }
  std::cout << BOLD << CYAN << std::left << std::string(3.5 * w, '-') << RESET
            << std::endl;
}
int main() {
  get_tokens("input.cc");
  yyparse();
  print_symbol_table(symbol_table);
  return 0;
}