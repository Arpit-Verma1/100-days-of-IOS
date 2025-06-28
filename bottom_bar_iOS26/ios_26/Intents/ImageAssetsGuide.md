# 🍽️ Indian Food Images Guide for Thali Combo Builder

## Required Images for Assets.xcassets

You need to add the following images to your `Assets.xcassets` folder. Create an `imageset` for each one (similar to how you have `latte.imageset`).

### Main Course Images:
1. **butterChicken.imageset** - Butter Chicken dish
2. **paneerTikka.imageset** - Paneer Tikka dish  
3. **dalMakhani.imageset** - Dal Makhani dish
4. **chickenTikka.imageset** - Chicken Tikka dish
5. **mixedVegetables.imageset** - Mixed Vegetables dish

### Bread Images:
6. **naan.imageset** - Naan bread
7. **roti.imageset** - Roti bread
8. **paratha.imageset** - Paratha bread
9. **kulcha.imageset** - Kulcha bread
10. **bhatura.imageset** - Bhatura bread

### Rice Image:
11. **rice.imageset** - Rice portion

### Side Dish Images:
12. **raita.imageset** - Raita (yogurt side dish)
13. **pickle.imageset** - Pickle
14. **papad.imageset** - Papad (crispy flatbread)
15. **salad.imageset** - Fresh salad
16. **curd.imageset** - Curd/yogurt
17. **chutney.imageset** - Chutney

## How to Add Images:

1. **Right-click** on `Assets.xcassets` in Xcode
2. **Select "New Image Set"**
3. **Name it** exactly as shown above (e.g., `butterChicken`)
4. **Drag and drop** your image file into the appropriate slot
5. **Repeat** for all 17 images

## Image Requirements:
- **Format**: PNG or JPG
- **Size**: 200x200px minimum (larger is fine)
- **Aspect Ratio**: Square (1:1) works best
- **Background**: Transparent or white background preferred

## Where to Find Images:
- **Free stock photo sites**: Unsplash, Pexels, Pixabay
- **Food photography sites**: FoodiesFeed
- **Create your own**: Take photos of actual dishes
- **Purchase**: Shutterstock, iStock, etc.

## Example Image Set Structure:
```
Assets.xcassets/
├── butterChicken.imageset/
│   ├── Contents.json
│   └── butterChicken.jpg
├── paneerTikka.imageset/
│   ├── Contents.json
│   └── paneerTikka.jpg
└── ... (repeat for all images)
```

## Quick Test:
Once you add the images, the Thali Combo Builder will automatically display them instead of the placeholder SF Symbols. The interface will become much more visually appealing and interactive!

## Fallback:
If any image is missing, the app will gracefully fall back to using SF Symbols, so it won't crash. 