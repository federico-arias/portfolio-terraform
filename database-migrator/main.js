import { execFile } from "child_process"
import path from 'path'

export const handler = async (event) => {
	// const { stdout, stderr } = await execa.command('node node_modules/@prisma/cli/build/index.js generate')
	// const prismaSchema = join(process.env.LAMBDA_TASK_ROOT || '', './prisma/schema.prisma')
	// const prismaExecutable = join(process.env.LAMBDA_RUNTIME_DIR || '', './node_modules/.bin/prisma')
	// const { stdout, stderr } = await execa(pismaExecutable, ['migrate', 'deploy', `--schema=${prismaSchema}`])

	try {
		const exitCode = await new Promise((resolve, _) => {
			execFile(
				path.resolve("./node_modules/prisma/build/index.js"),
				["migrate", "deploy"].concat([]),
				(error, stdout, stderr) => {
					console.log(stdout);
					if (error != null) {
						console.log(`prisma migrate exited with error ${error.message}`);
						resolve(error.code ?? 1);
					} else {
						resolve(0);
					}
				},
			);
		});

		if (exitCode != 0) throw Error(`command failed with exit code ${exitCode}`);
	} catch (e) {
		console.log(e);
		throw e;
	}

	return {
		statusCode: 200,
		body: JSON.stringify(
			{
				message: 'Gó Sørverless v1.0! Your function executed successfully!',
				input: event,
				env: process.env,
			},
			null,
			2,
		),
	}
}
