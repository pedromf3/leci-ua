import org.antlr.v4.runtime.*;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

public class Main {
    public static void main(String[] args) throws IOException {
        if (args.length < 1) {
            System.err.println("Uso: java Main <ficheiro.txt>");
            System.exit(1);
        }

        String sourceFile = args[0];
        String sourceCode = Files.readString(Paths.get(sourceFile));

        // Lexer e Parser
        CharStream input = CharStreams.fromString(sourceCode);
        BigIntCalcLexer lexer = new BigIntCalcLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        BigIntCalcParser parser = new BigIntCalcParser(tokens);

        // Parse da árvore de sintaxe
        BigIntCalcParser.ProgramContext tree = parser.program();

        // Compilador gera código Java
        Compiler compiler = new Compiler();
        String generatedCode = compiler.visit(tree);

        // Output do código gerado
        System.out.println("=== Código Java Gerado ===\n");
        System.out.println(generatedCode);

        // Guardar em ficheiro
        String outputFile = "GeneratedCalculator.java";
        Files.writeString(Paths.get(outputFile), generatedCode);
        System.out.println("\n=== Código salvo em: " + outputFile + " ===");
    }
}
