
import java.io.File;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.util.List;
import java.util.ArrayList;
import java.util.Queue;
import java.util.LinkedList;

class Set {
    public List<CacheLine> lines;
    public Queue<Integer> accesses;
    public Set(long numLines) {
        CacheLine cl = new CacheLine(0);
        this.lines = new ArrayList<CacheLine>();
        this.accesses = new LinkedList<Integer>();
        for (int i = 0; i < numLines; ++i) {
            cl = new CacheLine(i);
            this.lines.add(cl);
            this.access(cl);
        }
    }
    public void access(CacheLine cl) {
        this.accesses.add(cl.getIndex());
    }
    public int getLRU() {
        return this.accesses.remove();
    }
}

class CacheLine {
    private boolean valid;
    private long tag;
    private long data;
    private int index;

    public int getIndex() {
        return this.index;
    }

    public long getTag() {
        return this.tag;
    }

    public long getData() {
        return this.data;
    }

    public boolean isValid() {
        return this.valid;
    }

    public void setValid(boolean valid) {
        this.valid = valid;
    }

    public void setTag(long tag) {
        this.tag = tag;
    }

    public CacheLine(int index) {
        this.index = index;
    }
}

class Cache {
    // --------------------------------------------
    // This was not in lab07. Don't remove it !!!!!!!!
    private String writeAllocPolicy;
    // --------------------------------------------

    private int  blockSize;
    private int  associativity;
    private long capacity;

    // -----------------------------------------------------------
    // In addition to your code from lab07,
    // ADD ANY OTHER VARIABLES NEEDED FOR CACHE CONFIGURATION HERE
    // - add structures for your cache (tag storage, valid bits, etc)
    // -----------------------------------------------------------
    private long sets;
    private long s;
    private long b;

    // -----------------------------------------------------------
    // Event counters (read/write hits, misses, etc)
    private long readHits;
    private long writeHits;
    private long readMisses;
    private long writeMisses;
    private long numRefills;   // Data transfers from main mem, due to misses
    private long numAccesses;

    // Initialize any data structures for the cache
    //  and counters of events.
    List<Set> cache;
    private void initCache() {
        // --------------------------------------------------------------------
        // Initialize your cache data structures here
        // --------------------------------------------------------------------

        // Clear event counters
        readHits = 0;
        writeHits = 0;
        readMisses = 0;
        writeMisses = 0;
        numRefills = 0;
        numAccesses = 0;

        long lines = capacity / blockSize;
        cache = new ArrayList<Set>();
        for (int i = 0; i < sets; ++i) {
            cache.add(new Set(lines / sets));
        }
    }

    // The main cache method.
    // process operation op (R-ead, W-rite) at address addr
    //    update cache structures and update event counters
    public void access(String op, long addr) {
        // -----------------------------------------------------------
        // Write your code here
        // -----------------------------------------------------------
        ++numAccesses;
        Set S = cache.get((int)getIndex(addr));
        CacheLine hitcl = new CacheLine(999);
        boolean hit = false;
        int lruloc = 0;
        for (CacheLine cl : S.lines) {
            if (cl.getTag() == getTag(addr)) {
                System.out.println("tag matched");
                if (cl.isValid()) {
                    System.out.println("hit");
                    hit = true;
                    hitcl = cl;
                    break;
                }
            }
        }

        if (hit) {
            S.access(hitcl);
        }
        switch (op) {
            case "R":
                if (hit) {
                    ++readHits;
                    break;
                }

                // miss
                ++readMisses;
                ++numRefills;
                System.out.println("miss!");
                lruloc = S.getLRU();
                S.lines.get(lruloc).setTag(getTag(addr));
                S.lines.get(lruloc).setValid(true);
                S.access(S.lines.get(lruloc));
                break;
            case "W":
                if (hit) {
                    ++writeHits;
                    hitcl.setTag(getTag(addr));
                    hitcl.setValid(true);
                    // TODO: should we count for more memory reads here?
                    ++numRefills;
                    break;
                }

                // miss
                ++writeMisses;
                ++numRefills;
                lruloc = S.getLRU();
                S.lines.get(lruloc).setTag(getTag(addr));
                S.lines.get(lruloc).setValid(true);
                S.access(S.lines.get(lruloc));
                // TODO: count memory reads based on write-{no-,}allocate
                break;
        }
    }

    public void report() {
        System.out.printf("Total Accesses: %d\n", numAccesses);
        System.out.printf("Read hits: %d\n", readHits);
        System.out.printf("Write hits: %d\n", writeHits);
        System.out.printf("Read misses: %d\n", readMisses);
        System.out.printf("Write misses: %d\n", writeMisses);
        System.out.printf("Number of cache refils: %d\n", numRefills);
        System.out.printf("Miss rate: %f\n", (double) (readMisses + writeMisses)/numAccesses);
    }

    private long log2(long x) {
        return (long)(Math.log(x) / Math.log(2));
    }

    // Constructor
    public Cache(String[] args) {

        if (args.length < 4) {
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
        // --------------------------------------------
        // THIS WAS NOT IN LAB07. DON'T REMOVE IT !!!!!!!!
        // --------------------------------------------
        writeAllocPolicy = args[3];

        // -----------------------------------------------------------
        // Replace with your code from lab07
        //  ---
        // Don't forget to call InitCache() below!!!!
        // -----------------------------------------------------------

        sets = (capacity / blockSize) / associativity;
        b = log2(blockSize);
        s = log2(sets);

        initCache();
    }

    public long getTag(long addr) {
        // -----------------------------------------------------------
        // Replace with your code from lab07
        // -----------------------------------------------------------
        return addr >>> (b + s);
    }

    public long getIndex(long addr) {
        // -----------------------------------------------------------
        // Replace with your code from lab07
        // -----------------------------------------------------------
        return (addr >>> b) & (sets - 1);
    }

    public long getBoff(long addr) {
        // -----------------------------------------------------------
        // Replace with your code from lab07
        // -----------------------------------------------------------
        return addr & (blockSize - 1);
    }

}

class Lab08 {

    public static void main(String[] args) throws IOException {
        // Create and initialise a cache
        Cache cache = new Cache(args);

        String fileName = args[4];
        File f = new File(fileName);
        if (!f.exists() || f.isDirectory()) {
            System.err.println("Argument" + args[4] + " must be a file.");
            System.exit(1);
        }

        long lineNo = 1;
        Pattern p = Pattern.compile("([RW]) ([0-9a-fA-F]+)");
        try (BufferedReader br = new BufferedReader(new FileReader(f))) {
            for(String line; (line = br.readLine()) != null; ) {
                // Parse the line to get operation type and address
                Matcher m = p.matcher(line);
                if (!m.matches()) {
                    System.err.println("ERROR: Trace file problem at line " + Long.toString(lineNo));
                    System.exit(1);
                }
                String op = m.group(1);
                long addr = Long.parseLong(m.group(2), 16);

                // process the operation type, address
                cache.access(op, addr);
            }
        }
        // Print out the results
        cache.report();
    }
}
