import fetch from 'node-fetch';
import { context, getOctokit } from '@actions/github';
import { resolveUpdateLog } from './updatelog.mjs';

const UPDATE_TAG_NAME = 'updater';
const UPDATE_JSON_FILE = 'update.json';

/// generate update.json
/// upload to update tag's release asset
async function resolveUpdater() {
	if (process.env.GITHUB_TOKEN === undefined) {
		throw new Error('GITHUB_TOKEN is required');
	}

	const options = { owner: context.repo.owner, repo: context.repo.repo };
	const github = getOctokit(process.env.GITHUB_TOKEN);

	const { data: tags } = await github.rest.repos.listTags({
		...options,
		per_page: 10,
		page: 1,
	});

	// get the latest publish tag
	const tag = tags.find((t) => t.name.startsWith('v'));

	console.log(tag);
	console.log();

	const { data: latestRelease } = await github.rest.repos.getReleaseByTag({
		...options,
		tag: tag.name,
	});

	let notes = '';
	try {
		// use updatelog.md
		notes = await resolveUpdateLog(tag.name);
	} catch (err) {
		console.error(`[ERROR]: `, err.message);
	}

	const updateData = {
		name: tag.name,
		notes,
		pub_date: new Date().toISOString(),
		platforms: {
			'darwin-aarch64': { signature: '', url: '' },
			'darwin-x86_64': { signature: '', url: '' },
			'linux-x86_64': { signature: '', url: '' },
			'linux-aarch64': { signature: '', url: '' },
			'windows-x86_64': { signature: '', url: '' },
			'windows-aarch64': { signature: '', url: '' },
		},
	};

	const promises = latestRelease.assets.map(async (asset) => {
		const { name, browser_download_url } = asset;

		// win64 url
		if (name.endsWith('x64-setup.nsis.zip')) {
			
		}
	});
}

resolveUpdater().catch(console.error);
