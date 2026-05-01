// Generated from BigIntCalc.g4 by ANTLR 4.13.2
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link BigIntCalcParser}.
 */
public interface BigIntCalcListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link BigIntCalcParser#program}.
	 * @param ctx the parse tree
	 */
	void enterProgram(BigIntCalcParser.ProgramContext ctx);
	/**
	 * Exit a parse tree produced by {@link BigIntCalcParser#program}.
	 * @param ctx the parse tree
	 */
	void exitProgram(BigIntCalcParser.ProgramContext ctx);
	/**
	 * Enter a parse tree produced by {@link BigIntCalcParser#stat}.
	 * @param ctx the parse tree
	 */
	void enterStat(BigIntCalcParser.StatContext ctx);
	/**
	 * Exit a parse tree produced by {@link BigIntCalcParser#stat}.
	 * @param ctx the parse tree
	 */
	void exitStat(BigIntCalcParser.StatContext ctx);
	/**
	 * Enter a parse tree produced by {@link BigIntCalcParser#display_expr}.
	 * @param ctx the parse tree
	 */
	void enterDisplay_expr(BigIntCalcParser.Display_exprContext ctx);
	/**
	 * Exit a parse tree produced by {@link BigIntCalcParser#display_expr}.
	 * @param ctx the parse tree
	 */
	void exitDisplay_expr(BigIntCalcParser.Display_exprContext ctx);
	/**
	 * Enter a parse tree produced by {@link BigIntCalcParser#assignment}.
	 * @param ctx the parse tree
	 */
	void enterAssignment(BigIntCalcParser.AssignmentContext ctx);
	/**
	 * Exit a parse tree produced by {@link BigIntCalcParser#assignment}.
	 * @param ctx the parse tree
	 */
	void exitAssignment(BigIntCalcParser.AssignmentContext ctx);
	/**
	 * Enter a parse tree produced by the {@code unaryExpr}
	 * labeled alternative in {@link BigIntCalcParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterUnaryExpr(BigIntCalcParser.UnaryExprContext ctx);
	/**
	 * Exit a parse tree produced by the {@code unaryExpr}
	 * labeled alternative in {@link BigIntCalcParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitUnaryExpr(BigIntCalcParser.UnaryExprContext ctx);
	/**
	 * Enter a parse tree produced by the {@code addSubExpr}
	 * labeled alternative in {@link BigIntCalcParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterAddSubExpr(BigIntCalcParser.AddSubExprContext ctx);
	/**
	 * Exit a parse tree produced by the {@code addSubExpr}
	 * labeled alternative in {@link BigIntCalcParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitAddSubExpr(BigIntCalcParser.AddSubExprContext ctx);
	/**
	 * Enter a parse tree produced by the {@code mulDivModExpr}
	 * labeled alternative in {@link BigIntCalcParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterMulDivModExpr(BigIntCalcParser.MulDivModExprContext ctx);
	/**
	 * Exit a parse tree produced by the {@code mulDivModExpr}
	 * labeled alternative in {@link BigIntCalcParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitMulDivModExpr(BigIntCalcParser.MulDivModExprContext ctx);
	/**
	 * Enter a parse tree produced by the {@code parenExpr}
	 * labeled alternative in {@link BigIntCalcParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterParenExpr(BigIntCalcParser.ParenExprContext ctx);
	/**
	 * Exit a parse tree produced by the {@code parenExpr}
	 * labeled alternative in {@link BigIntCalcParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitParenExpr(BigIntCalcParser.ParenExprContext ctx);
	/**
	 * Enter a parse tree produced by the {@code numExpr}
	 * labeled alternative in {@link BigIntCalcParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterNumExpr(BigIntCalcParser.NumExprContext ctx);
	/**
	 * Exit a parse tree produced by the {@code numExpr}
	 * labeled alternative in {@link BigIntCalcParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitNumExpr(BigIntCalcParser.NumExprContext ctx);
	/**
	 * Enter a parse tree produced by the {@code idExpr}
	 * labeled alternative in {@link BigIntCalcParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterIdExpr(BigIntCalcParser.IdExprContext ctx);
	/**
	 * Exit a parse tree produced by the {@code idExpr}
	 * labeled alternative in {@link BigIntCalcParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitIdExpr(BigIntCalcParser.IdExprContext ctx);
}