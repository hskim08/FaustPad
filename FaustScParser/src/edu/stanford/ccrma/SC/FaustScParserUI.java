package edu.stanford.ccrma.SC;

import java.awt.Dimension;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.FilenameFilter;

import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JTextField;

public class FaustScParserUI extends JFrame {

	JButton openBT;
	JTextField filenameTF;
	JButton dirBT;
	JTextField dirTF;
	JButton createBT;

	JFileChooser fileChooser;
	JFileChooser dirChooser;

	File inFile;
	File outDir;
	
	FaustScParser parser = new FaustScParser();

	/**
	 * Constructor
	 */
	public FaustScParserUI() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setPreferredSize(new Dimension(480, 240));

		setTitle("Faust SC Parser");

		initComponents();

		buildFrame();
	}

	/**
	 * Initializes components.
	 */
	private void initComponents() {
		openBT = new JButton("Open");
		openBT.setPreferredSize(new Dimension(60, 30));
		openBT.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent arg0) {
				int returnVal = fileChooser.showOpenDialog(FaustScParserUI.this);
				if (returnVal == JFileChooser.APPROVE_OPTION) {
					inFile = fileChooser.getSelectedFile();

					filenameTF.setText(inFile.getName());
				}
			}
		});

		filenameTF = new JTextField();
		filenameTF.setPreferredSize(new Dimension(200, 30));
		filenameTF.setEditable(false);

		dirBT = new JButton("Open");
		dirBT.setPreferredSize(new Dimension(60, 30));
		dirBT.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent arg0) {
				int returnVal = dirChooser.showOpenDialog(FaustScParserUI.this);

				if (returnVal == JFileChooser.APPROVE_OPTION) {
					outDir = dirChooser.getSelectedFile();

					dirTF.setText(outDir.getName());
				}
			}
		});

		dirTF = new JTextField();
		dirTF.setPreferredSize(new Dimension(200, 30));
		dirTF.setEditable(false);

		createBT = new JButton("Create");
		createBT.setPreferredSize(new Dimension(75, 30));
		createBT.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent arg0) {
				createScFile(inFile, outDir);
			}
		});

		fileChooser = new JFileChooser();
		fileChooser.setFileSelectionMode(JFileChooser.FILES_AND_DIRECTORIES);

		dirChooser = new JFileChooser();
		dirChooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
	}

	/**
	 * Builds the frame.
	 */
	private void buildFrame() {
		setLayout(new GridBagLayout());
		GridBagConstraints c = new GridBagConstraints();

		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 0;
		c.gridy = 0;
		add(new JLabel("In File:"), c);

		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 1;
		c.gridy = 0;
		add(filenameTF, c);

		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 2;
		c.gridy = 0;
		add(openBT, c);

		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 0;
		c.gridy = 1;
		add(new JLabel("Out Dir:"), c);

		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 1;
		c.gridy = 1;
		add(dirTF, c);

		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 2;
		c.gridy = 1;
		add(dirBT, c);

		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 2;
		c.gridy = 2;
		add(createBT, c);
	}

	/**
	 * create the supercollider file
	 */
	private void createScFile(File in, File out) {
		if (in == null || out == null)
			return;

		if (in.isDirectory()) {
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
			parser.createSingleFile(in, out);
		}
	}

	/** serial ID */
	private static final long serialVersionUID = 1L;

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		JFrame frame = new FaustScParserUI();

		frame.pack();
		frame.setVisible(true);
	}

}
