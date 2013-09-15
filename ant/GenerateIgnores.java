package amour.ant;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class GenerateIgnores{

	public static void main(String[] args){
		String path = args[0];
		try{
			printAllIgnores(path, path.length() + 1);
		}
		catch(IOException e){
			e.printStackTrace();
		}
	}

	private static void printAllIgnores(String path, int noPrintLength) throws IOException{
		recurseDirectory(path, noPrintLength);
		outputLoveIgnore(path, noPrintLength);
	}

	private static void recurseDirectory(String path, int noPrintLength) throws IOException{
		File root = new File(path);
		for(File cur: root.listFiles()){
			if(cur.isDirectory()){
				printAllIgnores(path + "/" + cur.getName(), noPrintLength);
			}
		}
	}

	private static void outputLoveIgnore(String path, int noPrintLength) throws IOException{
		File loveignore = new File(path + "/.loveignore");
		if(loveignore.exists()){
			BufferedReader reader = new BufferedReader(new FileReader(loveignore));
			String currentLine;
			while((currentLine = reader.readLine()) != null){
				System.out.print(printablePath(path, noPrintLength) + currentLine + "/**, ");
			}
		}
	}

	private static String printablePath(String path, int noPrintLength){
		String printablePath;
		if(noPrintLength > path.length()){
			printablePath = "";
		}
		else{
			printablePath = path.substring(noPrintLength) + "/";
		}

		return printablePath;
	}

}