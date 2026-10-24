# Connecting REA & Tempus Pay to GitHub

Follow these simple steps to push your project to GitHub and trigger the cloud build for your APK:

## Step 1: Create a Repository on GitHub
1. Go to [GitHub.com](https://github.com) and log in.
2. Click the **`+`** icon in the top right and select **New repository**.
3. Name your repository `tempus-pay`.
4. Choose **Public** or **Private**.
5. **Do NOT** check "Add a README file" (leave the repository completely empty).
6. Click **Create repository**.

## Step 2: Initialize & Push from Your Terminal
Open your terminal inside `C:\Users\Gabbar\Desktop\REA` and run the following commands (replace `YOUR_USERNAME` with your actual GitHub username):

```bash
# Initialize git and add all files
git add .
git commit -m "Initial commit for Tempus Pay UAT"

# Link your remote GitHub repository
git remote add origin https://github.com/YOUR_USERNAME/tempus-pay.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 3: Download Your APK
1. Go to your repository on GitHub.
2. Click on the **Actions** tab at the top.
3. You will see the **Build Tempus Pay APK** workflow running.
4. Once it turns green (usually 2-3 minutes), click on it, scroll down to **Artifacts**, and download `tempus-pay-release`.
5. Unzip the file to get your `app-release.apk`, transfer it to your Android phone, and install it!
