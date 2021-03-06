Class {
	#name : #BaselineOfCasinoAureliaExporter,
	#superclass : #BaselineOf,
	#category : #BaselineOfCasinoAureliaExporter
}

{ #category : #baselines }
BaselineOfCasinoAureliaExporter >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ self defineDependencies: spec.
			self definePackages: spec.
			self defineGroups: spec ]
]

{ #category : #baselines }
BaselineOfCasinoAureliaExporter >> defineDependencies: spec [
	spec
		baseline: 'CasinoModelSilverlight'
		with: [ spec
				repository: 'github://badetitou/Casino-Model-Silverlight:master/src' ]
]

{ #category : #baselines }
BaselineOfCasinoAureliaExporter >> defineGroups: spec [
	spec group: 'default' with: #('Casino-Aurelia-Exporter')
]

{ #category : #baselines }
BaselineOfCasinoAureliaExporter >> definePackages: spec [
	spec
		repository: 'https://github.com/badetitou/Casino-Aurelia-Exporter';
		package: 'BaselineOfCasinoAureliaExporter';
		package: 'Casino-Aurelia-Exporter'
			with: [ spec requires: #('CasinoModelSilverlight') ]
]
