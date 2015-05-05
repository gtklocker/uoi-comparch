// ----------------------------------------------------------------------------
// MYY-402 Computer Architecture
//  cse.uoi.gr
// ----------------------------------------------------------------------------
import java.io.File;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

class Cache {
    private int  blockSize;
    private int  associativity;
    private long capacity;

    // -----------------------------------------------------------
    // ADD ANY OTHER VARIABLES NEEDED FOR CACHE CONFIGURATION HERE
    // E.G.:
    // private long numSets;
    // -----------------------------------------------------------

    private long log2(long x) {
        return (long)(Math.log(x) / Math.log(2));
    }

    // Constructor
    public Cache(String[] args) {

        if (args.length < 3) {
            System.err.println("ERROR: Configuration info not provided. Exiting.");
            System.exit(1);
        }
        try {
            blockSize = Integer.parseInt(args[0]);
        } catch (NumberFormatException e) {
            System.err.println("Argument" + args[0] + " must be an integer.");
            System.exit(1);
        }
        try {
            associativity = Integer.parseInt(args[1]);
        } catch (NumberFormatException e) {
            System.err.println("Argument" + args[1] + " must be an integer.");
            System.exit(1);
        }
        try {
            capacity = Integer.parseInt(args[2]);
        } catch (NumberFormatException e) {
            System.err.println("Argument" + args[2] + " must be an integer.");
            System.exit(1);
        }
        // -----------------------------------------------------------
        // Complete code here for other cache parameters derived from the above.
        // -----------------------------------------------------------
    }

    public long getTag(long addr) {
        // -----------------------------------------------------------
        // Write code here
        // Replace return const below with the computed tag
        // -----------------------------------------------------------
        return addr >> (log2(blockSize) + log2((capacity / blockSize) / associativity));
    }

    public long getIndex(long addr) {
        // -----------------------------------------------------------
        // Write code here
        // Replace return const below with the computed index
        // -----------------------------------------------------------
        return (addr >> log2(blockSize)) & ((capacity / blockSize) / associativity - 1);
    }

    public long getBoff(long addr) {
        // -----------------------------------------------------------
        // Write code here
        // Replace return const below with the computed block offset
        // -----------------------------------------------------------
        long offset = addr & (blockSize - 1);
        return offset >> (log2(blockSize) - log2(associativity));
    }

}

class Lab07 {

    public static void main(String[] args) throws IOException {
        Cache cache = new Cache(args);

        String fileName = args[3];
        File f = new File(fileName);
        if (!f.exists() || f.isDirectory()) {
            System.err.println("Argument" + args[3] + " must be a file.");
            System.exit(1);
        }

        try (BufferedReader br = new BufferedReader(new FileReader(f))) {
            for(String line; (line = br.readLine()) != null; ) {
                // process the line.
                long addr = Long.parseLong(line, 16);

                long tag = cache.getTag(addr);
                long idx = cache.getIndex(addr);
                long boff = cache.getBoff(addr);
                System.out.printf("Address: %x => Tag: %x, Index: %x, Boff: %x\n", addr, tag, idx, boff);
            }
        }
    }
}
