package amour.ant;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.StringBuffer;

public class MinifyGame{

	public static void main(String[] args){
		String root = args[0];
		String path = args[1];
		File dirToMinify = new File(root, path);
		try{
			minifyAll(dirToMinify);
		}
		catch(IOException e){
			e.printStackTrace();
		}
	}

	private static void minifyAll(File root) throws IOException{
		for(File cur: root.listFiles()){
			if(cur.isDirectory()){
				minifyAll(cur);
			}
			else if(cur.getName().endsWith(".lua")){
				minifyLuaFile(cur.getAbsolutePath());
			}
		}
	}

	private enum StringState {NONE, SINGLE, DOUBLE}
	private static class FileOptimiserState{
		public char curChar;
		public char lastSeenChar;
		public char lastWrittenChar;
		public boolean lineComment = false;
		public boolean blockComment = false;
		public StringState inString = StringState.NONE;
		public StringBuffer buffer = new StringBuffer();

		public int setCurChar(int newChar){
			curChar = (char)newChar;
			return newChar;
		}
		public char setCurChar(char newChar){
			curChar = newChar;
			return newChar;
		}
		public int setLastSeenChar(int newChar){
			lastSeenChar = (char)newChar;
			return newChar;
		}
		public char setLastSeenChar(char newChar){
			lastSeenChar = newChar;
			return newChar;
		}
		public int setLastWrittenChar(int newChar){
			lastWrittenChar = (char)newChar;
			return newChar;
		}
		public char setLastWrittenChar(char newChar){
			lastWrittenChar = newChar;
			return newChar;
		}
	}

	private static void minifyLuaFile(String file) throws IOException{
		File lua = new File(file);
		File tempLua = new File(file.replaceAll(".lua", ".tmp"));
		BufferedReader reader = new BufferedReader(new FileReader(lua));
		BufferedWriter writer = new BufferedWriter(new FileWriter(tempLua));
		FileOptimiserState fo = new FileOptimiserState();

		minifyAndWrite(writer, reader, fo);
		reader.close();
		writer.close();

		lua.delete();
		tempLua.renameTo(lua);
	}

	private static void minifyAndWrite(BufferedWriter writer, BufferedReader reader, FileOptimiserState fo)
			throws IOException{
		while((fo.setCurChar(reader.read())) != -1){
			if(fo.lineComment){
				ensureStillLineComment(fo);
				continue;
			}
			if(fo.blockComment){
				ensureStillBlockComment(fo);
				continue;
			}
			if(Character.isWhitespace(fo.curChar)){
				if(fo.buffer.length() == 0){
					continue;
				}
				else{
					writeAndUpdateState(writer, fo, 0);
				}
			}
			else{
				fo.buffer.append(fo.curChar);
			}

			checkIfCommentStarted(writer, fo);
			openOrCloseStringState(fo);

			fo.setLastSeenChar(fo.curChar);
		}
		if(!fo.blockComment && !fo.lineComment){
			writeAndUpdateState(writer, fo, 0);
		}
	}

	private static void openOrCloseStringState(FileOptimiserState fo){
		if(fo.inString == StringState.SINGLE){
			if(fo.curChar == '\'' && fo.lastSeenChar != '\\'){
				fo.inString = StringState.NONE;
			}
		}
		else if(fo.inString == StringState.DOUBLE){
			if(fo.curChar == '"' && fo.lastSeenChar != '\\'){
				fo.inString = StringState.NONE;
			}
		}
		else{
			if(fo.curChar == '\''){
				fo.inString = StringState.SINGLE;
			}
			else if(fo.curChar == '"'){
				fo.inString = StringState.DOUBLE;
			}
		}
	}

	private static boolean doesNeedWhitespace(char firstChar, char lastWrittenChar){
		String nonSpecialCharacterPattern = "[A-Za-z0-9_-]";
		return ((int)lastWrittenChar != 0
				&& Character.toString(lastWrittenChar).matches(nonSpecialCharacterPattern)
				&& Character.toString(firstChar).matches(nonSpecialCharacterPattern));
	}

	private static void checkIfCommentStarted(BufferedWriter writer, FileOptimiserState fo)
			throws IOException{
		if(fo.inString == StringState.NONE
				&& fo.buffer.toString().endsWith("--")){
			writeAndUpdateState(writer, fo, 2);
			fo.lineComment = true;
		}
	}

	private static void writeAndUpdateState(BufferedWriter writer,
			FileOptimiserState fo,
			int ignoreLength)
			throws IOException{
		String word = fo.buffer.toString();
		if(word.length() > ignoreLength){
			if(doesNeedWhitespace(fo.buffer.toString().charAt(0), fo.lastWrittenChar)){
				writer.write(" ");
			}

			word = word.substring(0, word.length() - ignoreLength);
			writer.write(word);
			fo.setLastWrittenChar(word.charAt(word.length() - 1));
		}

		fo.buffer = new StringBuffer();
	}

	private static boolean isEndOfLine(char curChar){
		return (curChar == (char)'\n'
				|| curChar == (char)'\r');
	}

	private static void ensureStillLineComment(FileOptimiserState fo){
		if(fo.curChar == '['){
			fo.buffer.append('[');
			if(fo.buffer.length() == 2){
				fo.buffer = new StringBuffer();
				fo.lineComment = false;
				fo.blockComment = true;
			}
		}
		else{
			if(isEndOfLine(fo.curChar)){
				fo.lineComment = false;
			}
			fo.buffer = new StringBuffer();
		}
	}

	private static void ensureStillBlockComment(FileOptimiserState fo){
		if(fo.buffer.length() < 3 && fo.curChar == '-'){
			if(fo.buffer.length() < 2){
				fo.buffer.append('-');
			}
		}
		else if(fo.buffer.length() >= 2 && fo.curChar == ']'){
			fo.buffer.append(']');

			if(fo.buffer.length() == 4){
				fo.blockComment = false;
				fo.buffer = new StringBuffer();
			}
		}
		else{
			fo.buffer = new StringBuffer();
		}
	}

}