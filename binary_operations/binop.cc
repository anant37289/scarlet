#include "binop.hh"

namespace scarlet {
namespace binop {

std::string to_string(BINOP binop) {
  switch (binop) {
  case ADD:
    return "ADD";
  case SUB:
    return "SUBTRACT";
  case MUL:
    return "MULTIPLY";
  case DIV:
    return "DIVIDE";
  case MOD:
    return "MODULO";
  case AAND:
    return "AAND";
  case AOR:
    return "AOR";
  case XOR:
    return "XOR";
  case LEFT_SHIFT:
    return "LEFT_SHIFT";
  case RIGHT_SHIFT:
    return "RIGHT_SHIFT";
  case LAND:
    return "LAND";
  case LOR:
    return "LOR";
  case EQUAL:
    return "EQUAL";
  case NOTEQUAL:
    return "NOTEQUAL";
  case LESSTHAN:
    return "LESSTHAN";
  case GREATERTHAN:
    return "GREATERTHAN";
  case LESSTHANEQUAL:
    return "LESSTHANEQUAL";
  case GREATERTHANEQUAL:
    return "GREATERTHANEQUAL";
  case ASSIGN:
    return "ASSIGN";
  case COMPOUND_DIFFERENCE:
    return "COMPOUND_DIFFERENCE";
  case COMPOUND_SUM:
    return "COMPOUND_SUM";
  case COMPOUND_DIVISION:
    return "COMPOUND_DIVISION";
  case COMPOUND_PRODUCT:
    return "COMPOUND_PRODUCT";
  case COMPOUND_REMAINDER:
    return "COMPOUND_REMAINDER";
  default:
    return "UNKNOWN";
  }
}

bool short_circuit(BINOP binop) { return binop == LAND or binop == LOR; }

bool is_relational(BINOP binop) {
  return binop == EQUAL or binop == NOTEQUAL or binop == LESSTHAN or
         binop == GREATERTHAN or binop == LESSTHANEQUAL or
         binop == GREATERTHANEQUAL;
}

} // namespace binop
} // namespace scarlet