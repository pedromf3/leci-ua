import org.stringtemplate.v4.ST;

@SuppressWarnings("CheckReturnValue")
public class Execute extends csvBaseVisitor<ST> {
   private boolean isHeader = true;

   @Override
   public ST visitProgram(csvParser.ProgramContext ctx) {
      ST tableST = new ST("<table>\n   $rows$</table>\n", '$', '$');

      for (csvParser.StatContext statCtx : ctx.stat()) {
         ST rowST = visit(statCtx);
         if (rowST == null) {
            throw new RuntimeException("visitStat returned null");
         }
         tableST.add("rows", rowST);
      }
      System.out.println(tableST.render());
      return null;
   }

   @Override
   public ST visitStat(csvParser.StatContext ctx) {
      ST rowST = new ST("<tr>\n$columns$</tr>\n", '$', '$');

      String tag = isHeader ? "th" : "td";
      isHeader = false;

      for (var textCtx : ctx.TEXT()) {
         ST cellST = new ST("    <$tag$>$val$</$tag$>\n", '$', '$');
         cellST.add("tag", tag);
         cellST.add("val", textCtx.getText());
         rowST.add("columns", cellST);
      }
      return rowST;
   }
}
