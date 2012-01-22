package edu.stanford.ccrma.SC;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class FaustScParser {

	List<String> paramList = new ArrayList<String>();
	List<Float> valueList = new ArrayList<Float>();

	public void createSingleFile(File file, File outDir) {

		// parse xml file and get parameter names and values
		Document dom = parseXML(file);
		parseDocument(dom);

		// create string content
		String content = createSynthDefFile(file, paramList, valueList);

		// parse title
		String name = file.getName();
		StringTokenizer tokenizer = new StringTokenizer(name, ".");
		String title = tokenizer.nextToken();

		// write to file
		String filename = new String(title + ".sc");
		File outFile = new File(outDir.getAbsoluteFile() + File.separator
				+ filename);

		try {
			Writer output = new BufferedWriter(new FileWriter(outFile));
			output.append(content);
			output.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * Creates the SynthDef file content.
	 * 
	 * @param file
	 *            - the input file
	 * @param pList
	 * @param vList
	 * @return
	 */
	private String createSynthDefFile(File file, List<String> pList,
			List<Float> vList) {
		// parse title
		String name = file.getName();
		StringTokenizer tokenizer = new StringTokenizer(name, ".");
		String title = tokenizer.nextToken();

		String content = new String();

		content += "SynthDef.new(";
		content += "\"" + title + "\", {\n";

		// arguments
		content += "\targ ";
		for (int i = 0; i < pList.size(); i++) {
			content += pList.get(i) + " = " + vList.get(i);
			content += (i == pList.size() - 1) ? ";\n" : ", ";
		}

		// Out.ar
		content += "\tOut.ar(0, Faust" + capitalize(title) + ".ar(";
		for (int i = 0; i < pList.size(); i++) {
			content += pList.get(i);
			content += (i == pList.size() - 1) ? "));\n" : ", ";
		}

		content += "}).load(s);\n";

		return content;
	}

	/**
	 * Parses the dsp.xml file
	 * 
	 * @param file
	 * @return
	 */
	private Document parseXML(File file) {
		// get the factory
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();

		Document dom = null;

		try {
			// Using factory get an instance of document builder
			DocumentBuilder db = dbf.newDocumentBuilder();

			// parse using builder to get DOM representation of the XML file
			dom = db.parse(file);

		} catch (Exception ioe) {
			ioe.printStackTrace();
		}

		return dom;
	}

	/**
	 * Parses the DOM object and creates a list of parameters.
	 * 
	 * @param dom
	 */
	private void parseDocument(Document dom) {
		// get the root element
		Element docEle = dom.getDocumentElement();

		// get a nodelist of elements
		NodeList nl = docEle.getElementsByTagName("widget");

		paramList.clear();
		valueList.clear();

		if (nl != null && nl.getLength() > 0) {
			for (int i = 0; i < nl.getLength(); i++) {

				Element widget = (Element) nl.item(i);
				String label = getTextValue(widget, "label").toLowerCase().replace(' ', '_');
				String vString = getTextValue(widget, "init");

				Float value = new Float(0);
				if (vString != null) {
					value = Float.parseFloat(vString);
				}

				paramList.add(label);
				valueList.add(value);
			}
		}
	}

	private String getTextValue(Element ele, String tagName) {
		String textVal = null;
		NodeList nl = ele.getElementsByTagName(tagName);

		if (nl != null && nl.getLength() > 0) {
			Element el = (Element) nl.item(0);
			textVal = el.getFirstChild().getNodeValue();
		}

		return textVal;
	}

	private String capitalize(final String string) {
		if (string == null)
			throw new NullPointerException("string");
		if (string.equals(""))
			throw new NullPointerException("string");

		return Character.toUpperCase(string.charAt(0)) + string.substring(1);
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO: validate arguments
		
		File inFile = new File(args[0]);
		File outDir = new File(args[1]);
		
		if(inFile.isDirectory()) {
			
			FilenameFilter filter = new FilenameFilter() {
			    public boolean accept(File dir, String name) {
			        return name.endsWith(".dsp.xml");
			    }
			};
			
			String[] files = inFile.list(filter);
			FaustScParser parser = new FaustScParser();
			for(int i = 0; i < files.length; i++) {
				System.out.println("Parsing " + inFile.getAbsolutePath()+File.separator+files[i]);
				parser.createSingleFile(new File(inFile.getAbsolutePath()+File.separator+files[i]), outDir);
			}
			
		} else {
			FaustScParser parser = new FaustScParser();
			parser.createSingleFile(inFile, outDir);
		}
	}
}
