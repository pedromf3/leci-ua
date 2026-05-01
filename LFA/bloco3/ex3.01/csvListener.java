// Generated from csv.g4 by ANTLR 4.13.2
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link csvParser}.
 */
public interface csvListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link csvParser#program}.
	 * @param ctx the parse tree
	 */
	void enterProgram(csvParser.ProgramContext ctx);
	/**
	 * Exit a parse tree produced by {@link csvParser#program}.
	 * @param ctx the parse tree
	 */
	void exitProgram(csvParser.ProgramContext ctx);
	/**
	 * Enter a parse tree produced by {@link csvParser#stat}.
	 * @param ctx the parse tree
	 */
	void enterStat(csvParser.StatContext ctx);
	/**
	 * Exit a parse tree produced by {@link csvParser#stat}.
	 * @param ctx the parse tree
	 */
	void exitStat(csvParser.StatContext ctx);
}