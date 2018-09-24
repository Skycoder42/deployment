#!/usr/bin/env python3
# $1: flatpak.json

import sys
import json
import os.path


class FlatMod:
	id: str = ""
	depends: list

	def __init__(self):
		self.depends = []

	def __repr__(self):
		return self.id + "[" + ", ".join(self.depends) + "]"

	def __eq__(self, other):
		return self.id == other.id

	def __ne__(self, other):
		return self.id != other.id

	def __hash__(self):
		return self.id.__hash__()

	def resolve_depends(self) -> list:
		reslist = []
		self.resolve_depends_impl(reslist)
		result = []
		seen = set()
		for item in reslist:
			if item not in seen:
				seen.add(item)
				result.append(item.full_path())
		return result

	def full_path(self) -> str:
		return os.path.join("modules", self.id, self.id + ".json")

	@staticmethod
	def load(path: str):
		with open(path, "r") as infile:
			mod = FlatMod()
			mod.id = os.path.splitext(os.path.basename(path))[0]
			data = json.load(infile)
			mod.depends = data["depends"] if "depends" in data else []
			return mod, data

	def resolve_depends_impl(self, deplist: list):
		for dep in self.depends:
			mod_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), "modules", dep, dep + ".json")
			sub_dep, discard = FlatMod.load(mod_path)
			sub_dep.resolve_depends_impl(deplist)
			deplist.append(sub_dep)


def flatdep(target: str):
	root_mod, json_data = FlatMod.load(target)
	deplist = root_mod.resolve_depends()
	with open(os.path.join(os.path.dirname(os.path.realpath(__file__)), "flatdep-modules.json"), "w") as out_file:
		mod_json = {
			"name": "flatdep-modules",
			"buildsystem": "simple",
			"modules": deplist,
			"sources": [
				{
					"type": "file",
					"path": "qt.conf"
				}
			],
			"build-commands": [
				"install -D -m644 qt.conf /app/bin/qt.conf"
			]
		}
		json.dump(mod_json, out_file, indent=4)


if __name__ == '__main__':
	flatdep(sys.argv[1])
