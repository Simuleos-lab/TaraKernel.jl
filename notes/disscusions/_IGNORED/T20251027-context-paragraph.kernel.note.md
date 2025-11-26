- #IDEA
- This is a label, or a tag

- #DESIGN
- Everything default to root
- If you succesfully trigger an indent change the current index is moved
- You can set many indent changes

- #ContextParagrph and code comments
```julia -i1
let
    A = 1 # "units": "mM", "type": "Conc"
end
```
    - Add an indent, so the code is a child of previous line
    - important, this operation is reverted at the end of the julia block
    - This is a parser action further from the raw tree
    - For the raw tree, all the lines go to root execpt this ones and the code line

***
- A ContextParagraph is always in a tree
- The simplest one is a list with next and preview relationships. 
- The sequential nature of reading (no parallelizable) makes this always possible to implement. 
- That is, any context derived from text will have a local sequencial nature. 
-- For instance: a `path -> line range`
-- An useful readingle unique key is desirable
--- Here is where funtions to LLMs might bright 
--- With a refresh capability
---- UnLink IDs are marked as such...

- #PARSER
- the parsing mechanism is simple
- Start by the source tree (from text indent)
- Them execute commands from top to bottom
- Every time you execute a command, you check if it changed the tree
- If it did, you start executing again from the begining
- So, till a FIX POINT, the execution will continue 
    - Or till a MAX_ITER hit
- This way connections (ti keep the code simple) are forced to be unique
- Which is not Dificult
- Paragraphs are ~20 per file. 


- We can provide a programming lang which source is embeded on the tree
- For instance, if the tree is becoming very deep, you can say `indent -c`
- And the tree will know that you are continuing in the same scope
- There is a `pwd` which tells you the current scope. 
    - `pwd` 
        - outcome: /T/. 
            - Which means Im in a child of `T` (just the first nice letter) that is a child of root `/`
        - That is, the parser has a runtime that might be powerful
            - `continue -r "#NOTE"`
    - Everytime the text breack an indent is just a sugar for a command
        - For instance `cd .`
            - Which means, I will create childs...
            - Execution is a child is a `noop` #TAI

- #NOTE
- (you are in the same scope)
- The join is made by a regex that is match with the first line of a next paragraph. 
- If fail after N attempts
    - #TAI ignore and continue with the text scope...

***
#NOTE The base character is optional
For instance, here we are using "" instead of "- "
    The and off course it works
    Any interference needs to be resolve by the user using escaping
What really matther is the indentation groups
    Like in python
So, the Obsidian version is just a configuration file different from a vscode version.

***
#NOTE Actually, it is just Markdown a little bit
    I can be called ContextDown or ContextMD, like that
    `end`

***
Untagged notes default to something.
If you dont like that you can configure it to be a parser error.

***
- #NOTE
- Publishing sources (raw data) in a common secure trusted system is paramount.
    - This is the raw (grond zero) tree I taleked with tarek a week ago...
    - TAI Do we force an unique source tree (?)
        - No, the community desides.
        - For instance, sail on top of github as a distributed (register coordinated) network.
            - The registry load can be split into a system distributed across n repos.
            - All repos are downloaded and cached as a single space.

***
- #Systems Formalize ContextParagraphs as an standard.
    - Make parser in Julia...


***
- #Make a Obsidian theme that is better with ContextParagraphs. 

***

- #IDEA/ Obsidian tag system everywhere.
- make a svcode extenssion 
    - Autocomplete ans search/suggest/learn your tagging proccess.
    - Add an vscode snniper
- In any commented block on any lang
- Make a terminal cli
    - have an Scope configuration
    - have a queryble language
    - TAI/ integration with ContextWW


***
 #Research/IDEA krypographic booleans
 - A package for instance to share configuration files or the universal context tree
 - we can increase a lot the trust we have on non corroption by using as the deffinition of the boolean the success of decription...
 - You can encript more than one bit too, an agreed msg (hard to guest).
 - 

***
 LLM IDEA, take the commit history and make a text history of the development process...
 - in notebookML it can be done, you add all the versions as a timi-tagged file
