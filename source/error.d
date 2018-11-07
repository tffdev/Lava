module error;
import std.stdio;

enum {
	missingFile = "CANNOT FIND FILE:",
	outOfBounds = "SPRITE INDEX IS OUT OF BOUNDS:"
}

void report(string type, string data){
	printf("\nERROR:\n=========\n%s %s\n",
		cast(char*)type, cast(char*)data);
}