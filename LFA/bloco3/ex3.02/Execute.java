import java.util.*;
import java.math.BigInteger;

@SuppressWarnings("CheckReturnValue")
public class Execute extends BigIntCalcBaseVisitor<String> {

    private Map<String, String> vars = new HashMap<>();

    @Override
    public String visitProgram(BigIntCalcParser.ProgramContext ctx) {
        StringBuilder code = new StringBuilder();
        code.append("import java.math.BigInteger;\n\n");
        code.append("public class GeneratedCalculator {\n");
        code.append("    public static void main(String[] args) {\n");
        
        for (BigIntCalcParser.StatContext stat : ctx.stat()) {
            String statCode = visit(stat);
            if (statCode != null && !statCode.isEmpty()) {
                code.append("        ").append(statCode).append("\n");
            }
        }
        
        code.append("    }\n");
        code.append("}\n");
        return code.toString();
    }

    @Override
    public String visitStat(BigIntCalcParser.StatContext ctx) {
        if (ctx.display_expr() != null) {
            return visit(ctx.display_expr());
        } else if (ctx.assignment() != null) {
            return visit(ctx.assignment());
        }
        return "";
    }

    @Override
    public String visitDisplay_expr(BigIntCalcParser.Display_exprContext ctx) {
        String expr = visit(ctx.expr());
        return "System.out.println(" + expr + ");";
    }

    @Override
    public String visitAssignment(BigIntCalcParser.AssignmentContext ctx) {
        String varName = ctx.ID().getText();
        String exprCode = visit(ctx.expr());
        vars.put(varName, exprCode);
        return "BigInteger " + varName + " = " + exprCode + ";";
    }

    @Override
    public String visitNumExpr(BigIntCalcParser.NumExprContext ctx) {
        String num = ctx.NUM().getText();
        return "new BigInteger(\"" + num + "\")";
    }

    @Override
    public String visitIdExpr(BigIntCalcParser.IdExprContext ctx) {
        String id = ctx.ID().getText();
        if (!vars.containsKey(id)) {
            throw new RuntimeException("Variável não definida: " + id);
        }
        return id;
    }

    @Override
    public String visitParenExpr(BigIntCalcParser.ParenExprContext ctx) {
        return "(" + visit(ctx.expr()) + ")";
    }

    @Override
    public String visitUnaryExpr(BigIntCalcParser.UnaryExprContext ctx) {
        String expr = visit(ctx.expr());
        String op = ctx.op.getText();
        
        if (op.equals("-")) {
            return "(" + expr + ").negate()";
        } else {
            return expr;  // unário +, sem efeito
        }
    }

    @Override
    public String visitAddSubExpr(BigIntCalcParser.AddSubExprContext ctx) {
        String left = visit(ctx.expr(0));
        String right = visit(ctx.expr(1));
        String op = ctx.op.getText();
        
        String method = op.equals("+") ? "add" : "subtract";
        return "(" + left + ")." + method + "(" + right + ")";
    }

    @Override
    public String visitMulDivModExpr(BigIntCalcParser.MulDivModExprContext ctx) {
        String left = visit(ctx.expr(0));
        String right = visit(ctx.expr(1));
        String op = ctx.op.getText();
        
        String method;
        if (op.equals("*")) {
            method = "multiply";
        } else if (op.equals("/")) {
            method = "divide";
        } else {
            method = "mod";
        }
        
        return "(" + left + ")." + method + "(" + right + ")";
    }
}
