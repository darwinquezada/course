
Supplementary Materials for "New Cluster Selection and Fine-grained Search for
k-Means Clustering and Wi-Fi Fingerprinting https://zenodo.org/record/3751042

This package includes the materials and methods to reproduce the results
presented in the paper detailed below. If you would like to re-use the software
provided and/or the empirical evaluation please cite the two following items. 

	Torres-Sospedra, J.; Quezada-Gaibor, D.; Mendoza-Silva, G. M.; Nurmi, J.;
	Koucheryavy, Y. and Huerta, J. "New Cluster Selection and Fine-grained Search
	for k-Means Clustering and Wi-Fi Fingerprinting". In Proceedings of the Tenth
	International Conference on Localization and GNSS (ICL-GNSS), 2020.

	Torres-Sospedra, J.; Quezada-Gaibor, D.; Mendoza-Silva, G. M.; Nurmi, J.;
	Koucheryavy, Y. and Huerta, J. "Supplementary Materials for 'New Cluster
	Selection and Fine-grained Search for k-Means Clustering and Wi-Fi
	Fingerprinting'", v1.0, Zenodo, 2020.  [Available Online]
	https://zenodo.org/record/3751042

If you would like to re-use the databases included in this paper, please cite
the corresponding sources as indicated in the readme file in the folder
'databases'.

If you want to re-run the experiments in your computer, please execute the
script executeAll (provided for MatLab/Octave and linux shell). A summary of the
results has been included to generate the figures and tables included in the
paper. If you want to generate the same figures for the results obtained with
your computer, please execute the script csv4all to generate the new summarized
results in the "Results_CSV" folder and modify the scripts included in folder
"Tables_and_Figures" to target the new summarized.

If you have any questions about this package, please do not hesitate to contact
J. Torres-Sospedra (jtorres@uji.es -- info@jtorr.es -- jtorres.phd@gmail.com).

--------------------------------------------------------------------------------
Contents of the package
--------------------------------------------------------------------------------
Main folders

	Zenodo_3751042\ -- Folder that includes the functions and scripts to  reproduce
	the work done in the ICL-GNSS paper

	Zenodo_3751042\Clusters -- Folder with the precalculated Clusters 

	Zenodo_3751042\databases -- Folder with the databases in .mat format (see
	readme.md on folder for additional information)

	Zenodo_3751042\Results -- Folder where the full results are  stored after
	executing a method on a dataset (please execute executeAll script) 

	Zenodo_3751042\Results_CSV -- Folder where the summarized results are stored to
	generate the plots and tables (please execute csv4all script) after executing a
	method on a dataset 

	Zenodo_3751042\Results_CSV_paper -- Folder with the summarized results shown in
	the paper

	Zenodo_3751042\Tables_and_Figures -- Folder with the scripts and functions
	required to generate the tables and figures included in the paper


Plain Fingerprint-based KNN Method

	Zenodo_3751042\knn_baseline.m -- Fingerprint method based on KNN. Requires the
	files below to work. Requires the database and execution parameters (provided
	by RunMethod)

	Zenodo_3751042\datarepExponential.m -- Converts RSSI to Exponential
	Representation 

	Zenodo_3751042\datarepPositive.m -- Converts RSSI to Positive Representation 

	Zenodo_3751042\datarepPowed.m -- Converts RSSI to Powed Representation

	Zenodo_3751042\datarepNewNull.m -- Replaces NaN Values (+100 in our datastes)
	to a new valid default value 

	Zenodo_3751042\datarepNewNullDB.m -- Replaces NaN Values (+100 in our datastes)
	to a new valid default value 

	*** Set of measures to compute the distance/similarity between fingerprints
	Zenodo_3751042\distance_cityblock.m  
	Zenodo_3751042\distance_LGD.m
	Zenodo_3751042\distance_PLGD10.m 
	Zenodo_3751042\distance_PLGD40.m
	Zenodo_3751042\distance_euclidean.m  
	Zenodo_3751042\distance_sorensen.m
	Zenodo_3751042\distance_hamming.m  
	Zenodo_3751042\distance_neyman.m
	Zenodo_3751042\distance_squaredeuclidean.m

	*** Compute the execution time  Zenodo_3751042\myTic.m Zenodo_3751042\myToc.m

	*** Remaps the buildingID and Floor ID to range 1...n
	Zenodo_3751042\remapBldDB.m 
	Zenodo_3751042\remapFloorDB.m
	Zenodo_3751042\remapVector.m

Improved Fingerprint-based KNN with optimization rules and clustering

	Zenodo_3751042\knn_moreira.m -- KNN with the optiomization rule proposed by
	Moreira

	Zenodo_3751042\knn_gallagher.m -- KNN with the optiomization rule proposed by
	Gallaguer

	Zenodo_3751042\knn_kmeans.m -- KNN with the a corase search using using k-means	Clustering 

	Zenodo_3751042\knn_kmeans_variant01.m -- KNN with the a corase search using
	using k-means Clustering with our proposed Variant 1

	Zenodo_3751042\knn_kmeans_variant02.m -- KNN with the a corase search using
	using k-means Clustering with our proposed Variant 2

	Zenodo_3751042\knn_kmeans_variant03.m -- KNN with the a corase search using
	using k-means Clustering with our proposed Variant 3

	Zenodo_3751042\localclustering_kmeans.m -- k-means Method needed to create the
	clusters

Run Methods

	Zenodo_3751042\runMethod.m -- Function to execute a KNN base method on a
	dataset with the appropriate parameters Example of usage:

	Zenodo_3751042\loadDatabase.m -- Loads the database structure with the training
	and testing data (including labels)

	Zenodo_3751042\mkSubdirs.m -- Generates subdirs if necessary

Scripts to run all the combinations

	Zenodo_3751042\generateScripts.m -- Generates the scripts to execute all
	combinations (see files below)

	Zenodo_3751042\executeAll.m -- Executes all the combinations tested in the
	paper (Matlab/Octave script)

	Zenodo_3751042\executeAll.sh -- Executes octave with the combinations tested in	the paper (shell script)

	Zenodo_3751042\getOptimalParams.m -- Given a datasets and a case, Simple 1-NN
	(2) or Best Params (3), returns the corresponding distance metrics, value of k
	and data represention

	Zenodo_3751042\getFeaturesDB.m -- Provides some base features of the dataset as	number of samples

Scripts to run a sample set

	Zenodo_3751042\generateScriptsSaple.m -- Generates the scripts to execute just
	a method based on each of the three variants (with k-means)

	Zenodo_3751042\executeSample.m -- Executes the sample set (results included in
	Results folder)


Scripts to summarize results

	Zenodo_3751042\csv4all.m -- Summarizes the results of all methods by using the
	function below (similarly csv4sample.m summarizes the sample set of	methods)

	Zenodo_3751042\results2csv.m -- Summarizes all the results files for a
	particular method to 2 files, one for the Simple 1-NN and one for the Best
	Params

	Zenodo_3751042\loadResults.m -- Loads result file

	Zenodo_3751042\accumulateResults.m -- Accumulates results from multiple runs 

Scripts to generate the figures and tables reported in the paper

	generate_Figures2to4.m -- Generates fig2_clusters_paper.pdf,
	fig3_samples_paper.pdf and fig4_samplesnorm_paper.pdf

	generate_Figure5.m -- Generates Fig5a_results_25.pdf, Fig5b_results_rfp1.pdf
	and Fig5c_results_rfp2.pdf

	generate_Table1.m -- Generates Table1.tex

	generate_Table2.m -- Generates Table2.tex

	generate_Table3.m -- Generates Table3.tex

	** Supporting functions  
	getAverageResultsMultiple.m 
	getAverageResultsSingle.m 
	printAverageResultsMultiple.m 
	printAverageResultsSingle.m 
	results4histograms.mat

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

This package includes the function localclustering_kmeans.m which was originally
included in Octave 5.1.0 Statistical Package as kmeans.m. It was developed by 
Soren Hauberg <soren@hauberg.org> (2011), Daniel Ward <dwa012@gmail.com> (2012) 
and Lachlan Andrew <lachlanbis@gmail.com> (2015-2016); and released under GNU
General Public License.

