pnpm install
pnpm check $INPUT_TARGET
sed -i "s/#openssl/openssl-sys={version=\"0.9\",features=[\"vendored\"]}/g" src-tauri/Cargo.toml

pnpm build --target $INPUT_TARGET
