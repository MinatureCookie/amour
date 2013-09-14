package amour.ant;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class GenerateIgnores{

	public static void main(String[] args){
		String path = ".";
		try{
			printAllIgnores(path);
		}
		catch(IOException e){
			e.printStackTrace();
		}
	}

	private static void printAllIgnores(String path) throws IOException{
		recurseDirectory(path);
		outputLoveIgnore(path);
	}

	private static void recurseDirectory(String path) throws IOException{
		File root = new File(path);
		for(File cur: root.listFiles()){
			if(cur.isDirectory()){
				printAllIgnores(path + "/" + cur.getName());
			}
		}
	}

	private static void outputLoveIgnore(String path) throws IOException{
		File loveignore = new File(path + "/.loveignore");
		if(loveignore.exists()){
			BufferedReader reader = new BufferedReader(new FileReader(loveignore));
			String currentLine;
			while((currentLine = reader.readLine()) != null){
				System.out.print(printablePath(path) + currentLine + "/**, ");
			}
		}
	}

	private static String printablePath(String path){
		String printablePath = path + "/";

		if(path.equals("") || path.equals(".")){
			printablePath = "";
		}
		else if(path.length() > 2 && path.substring(0, 2).equals("./")){
			printablePath = path.substring(2) + "/";
		}

		return printablePath;
	}

}